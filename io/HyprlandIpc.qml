pragma Singleton

import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import qs

Singleton {
	property string eventSocketPath: Hyprland.eventSocketPath
	property string requestSocketPath: Hyprland.requestSocketPath
	property HyprlandMonitor focusedMonitor: Hyprland.focusedMonitor
	property HyprlandWorkspace focusedWorkspace: Hyprland.focusedWorkspace
	property ObjectModel monitors: Hyprland.monitors
	property ObjectModel workspaces: Hyprland.workspaces

	property var workspacesById: {
		const result = {};
		for (const workspace of workspaces.values) {
			result[workspace.id] = workspace;
		}
		return result;
	}
	property string submap: ""
	property var overlayAddress: undefined
	property bool isOverlaid: overlayAddress !== undefined
	property var focusedScreen: Quickshell.screens.find(screen => screen.name === focusedMonitor?.name) ?? null
	property var bounds: Quickshell.screens.reduce((p, c) => {
		const x = Math.min(p.x, c.x)
		const y = Math.min(p.y, c.y)
		const r = Math.max(p.x + p.width, c.x + c.width)
		const b = Math.max(p.y + p.height, c.y + c.height)
		return { x, y, width: r - x, height: b - y }
	}, { x: 0, y: 0, width: 0, height: 0 })
	property QtObject activeWindow: QtObject {
		property string address: "0"
		property string title: ""
		property string klass: ""
	}
	property var windows: ({}) // { [address]: { workspace, klass, title, initialClass, initialTitle } }
	property list<var> clientsData: []
	property QtObject activeKeyboardLayout: QtObject {
		property string keyboard: "(unknown)"
		property string layout: "(unknown)"
	}

	property string windowWithUpdatedTitle: ""

	signal configReloaded()
	signal windowOpened(address: string, workspace: string, klass: string, title: string)
	signal windowClosed(address: string)
	signal windowFocused(klass: string, title: string)
	signal keyboardLayoutChanged(keyboard: string, layout: string)
	signal rawEvent(event: HyprlandEvent)

	Connections {
		target: Hyprland

		function onRawEvent(event: HyprlandEvent) {
			rawEvent(event)
			if (Config._.debug) {
				console.log("Hyprland [onRawEvent]:", JSON.stringify(event))
			}
			switch (event.name) {
				case "configreloaded": {
					configReloaded()
					break
				}
				case "submap": {
					submap = event.data
					break
				}
				case "openwindow": {
					const [address, workspace, klass, title] = event.parse(4)
					windowOpened(address, workspace, klass, title)
					const info = windows[address] ?? {}
					info.address = address
					info.workspace = workspace
					info.klass = klass
					info.title = title
					info.initialClass = klass
					info.initialTitle = title
					windows[address] = info
					exec("j", ["activewindow"], json => {
						const data = JSON.parse(json)
						const [x, y] = data.at
						const [width, height] = data.size
						if (
							x === bounds.x &&
							y === bounds.y &&
							width === bounds.width &&
							height === bounds.height
						) {
							overlayAddress = address
						}
					})
					break
				}
				case "closewindow": {
					const address = event.data
					delete windows[address]
					windowClosed(address)
					if (address === overlayAddress) {
						overlayAddress = undefined
					}
					break
				}
				case "windowtitle": {
					const address = event.data
					windowWithUpdatedTitle = address
					break
				}
				case "activewindow": {
					const [klass, title] = event.parse(2)
					activeWindow.klass = klass
					activeWindow.title = title
					windowFocused(klass, title)
					if (windowWithUpdatedTitle) {
						const info = windows[windowWithUpdatedTitle]
						if (info) {
							info.klass = klass
							info.title = title
							windows[windowWithUpdatedTitle] = info
						}
					}
					break
				}
				case "activewindowv2": {
					const address = event.data
					activeWindow.address = address
					windowWithUpdatedTitle = ""
					break
				}
				case "activelayout": {
					const [keyboard, layout] = event.parse(2)
					activeKeyboardLayout.keyboard = keyboard
					activeKeyboardLayout.layout = layout
					keyboardLayoutChanged(keyboard, layout)
					break
				}
				// TODO: handle `movewindow`
			}
		}
	}

	property var currentExec: null
	property var lastExec: null

	Socket {
		id: hyprctl
		onConnectedChanged: {
			if (connected) {
				if (currentExec) {
					write(currentExec.cmd)
					flush()
				}
			} else {
				currentExec?.onSuccess?.(currentExec.ret)
				if (currentExec) {
					currentExec = currentExec.next
				}
				if (currentExec) {
					hyprctl.connected = true
				} else {
					lastExec = null
				}
			}
		}
		path: requestSocketPath
		parser: SplitParser {
			splitMarker: ""
			onRead: data => {
				if (currentExec) {
					currentExec.ret = data
				}
				hyprctl.connected = false
			}
		}
	}

	function exec(flags, args, onSuccess) {
		const cmd = (flags ?? "") + "/" + args.join(" ")
		const exec = { cmd, onSuccess, ret: "", next: null }
		if (lastExec) {
			lastExec.next = exec
			lastExec = lastExec.next
		} else {
			currentExec = exec
			lastExec = exec
			hyprctl.connected = true
		}
	}

	Component.onCompleted: {
		exec("j", ["activewindow"], json => {
			const data = JSON.parse(json);
			activeWindow.address = data.address.slice(2);
			activeWindow.title = data.title;
			activeWindow.klass = data.class;
		});
		exec("j", ["clients"], json => {
			const data = JSON.parse(json)
			for (const datum of data) {
				const address = datum.address.slice(2);
				const info = windows[address] ?? {};
				info.address = address;
				info.klass = datum.class;
				info.title = datum.title;
				info.initialClass = datum.initialClass;
				info.initialTitle = datum.initialTitle;
				windows[datum.address] = info;
			}
		});
	}

	function focusWindow(id) {
		Hyprland.dispatch(`focuswindow ${id}`)
	}

	function focusWorkspace(address) {
		Hyprland.dispatch(`workspace ${address}`)
	}

	function focusWorkspaceOnCurrentMonitor(id) {
		Hyprland.dispatch(`workspace ${id}`)
	}

	function refetchClients() {
		exec("j", ["clients"], json => { clientsData = JSON.parse(json); });
	}

	function recomputeWorkspaces() {
		const result = Array.from({ length: Config._.workspaceCount }, (_, i) => ({
			id: i, x: 0, y: 0, width: 1920, height: 1080, clients: [],
		}));
		for (const workspace of workspaces.values) {
			if (!/^\d+$/.test(workspace.name)) continue;
			const screen = Quickshell.screens.find(m => m.name === workspace.monitor.name);
			result[workspace.id - 1] = {
				id: workspace.id,
				x: screen?.x ?? 0,
				y: screen?.y ?? 0,
				width: screen?.width ?? 1920,
				height: screen?.height ?? 1080,
				clients: [],
			};
		}
		for (const client of clientsData) {
			const boundingBox = result[client.workspace.id - 1];
			if (!boundingBox) continue;
			const info = {
				address: client.address,
				x: client.at[0] - boundingBox.x,
				y: client.at[1] - boundingBox.y,
				width: client.size[0],
				height: client.size[1],
				class: client.class,
				title: client.title,
				toplevel: ToplevelManager.toplevels.values.find(value => `0x${value.HyprlandToplevel?.address}` === client.address),
			}
			result[client.workspace.id - 1].clients.push(info);
		}
		return result;
	}
}
