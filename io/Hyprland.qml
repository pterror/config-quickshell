pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick
import ".."
import "../library/Promise.mjs" as Promise

Singleton {
	property string submap: ""
	property string activeMonitor: ""
	property var activeScreen: Quickshell.screens[0]
	property QtObject activeWindow: QtObject {
		property string address: "0"
		property string title: ""
		property string klass: ""
	}
	property list<var> windows: ({}) // { address: { workspace, klass, title, initialClass, initialTitle } }
	property list<var> workspaceInfosArray: Array.from({ length: 9 }, (_, i) => {
		return { id: i + 1, name: String(i + 1), focused: false, exists: false }
	})
	property var workspaceInfos: workspaceInfosArray.reduce((p, c) => { p[c.name] = c; return p }, {})
	property QtObject activeWorkspace: QtObject {
		property int id: 1
		property string name: "1"
	}
	property QtObject activeKeyboardLayout: QtObject {
		property string keyboard: "(unknown)"
		property string layout: "(unknown)"
	}

	property string windowToFocus: ""
	property string workspaceToFocus: ""
	property string workspaceToFocusOnCurrentMonitor: ""
	property string windowWithUpdatedTitle: ""

	signal configReloaded()
	signal windowOpened(address: string, workspace: string, klass: string, title: string)
	signal windowClosed(address: string)
	signal windowFocused(klass: string, title: string)
	signal monitorFocused(name: string, workspaceName: string)
	signal keyboardLayoutChanged(keyboard: string, layout: string)

	Socket {
		connected: true
		onConnectedChanged: connected = true
		path: `/tmp/hypr/${Quickshell.env("HYPRLAND_INSTANCE_SIGNATURE")}/.socket2.sock`

		parser: SplitParser {
			splitMarker: ""
			onRead: message => {
				if (Config.debug) {
					console.log("Hyprland [stdin]: " + message)
				}
				const lines = message.split(/\n(?=.+>>|$)/)
				for (const line of lines) {
					if (!line) continue
					const [, type, body] = line.match(/(.+)>>([\s\S]+)/)
					if (body === undefined) {
						console.log("Hyprland: error: malformed message: " + message)
						continue
					}
					const args = body.split(",")
					switch (type) {
						case "configreloaded": {
							configReloaded()
							break
						}
						case "submap": {
							[submap] = args
							if (submap === "quickshell:workspaces_overview:toggle") {
								Shell.workspacesOverview = !Shell.workspacesOverview
							}
							break
						}
						case "openwindow": {
							const [address, workspace, klass, title] = args
							windowOpened(address, workspace, klass, title)
							const info = windows[address] ?? {}
							info.address = address
							info.workspace = workspace
							info.klass = klass
							info.title = title
							info.initialClass = klass
							info.initialTitle = title
							windows[address] = info
							break
						}
						case "closewindow": {
							const [address] = args
							delete windows[address]
							windowClosed(address)
							break
						}
						case "windowtitle": {
							const [address] = args
							windowWithUpdatedTitle = address
							break
						}
						case "activewindow": {
							const [klass, title] = args
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
							const [address] = args
							activeWindow.address = address
							windowWithUpdatedTitle = ""
							break
						}
						case "activelayout": {
							const [keyboard, layout] = args
							activeKeyboardLayout.keyboard = keyboard
							activeKeyboardLayout.layout = layout
							keyboardLayoutChanged(id, layout)
							break
						}
						case "focusedmon": {
							const [monitor, workspace] = args
							activeMonitor = monitor
							activeScreen = Quickshell.screens.find(screen => screen.name === monitor)
							monitorFocused(monitor, workspace)
							for (const key in workspaceInfos) {
								const info = workspaceInfos[key]
								info.focused = info.name === workspace
								setWorkspaceInfo(info)
							}
							break
						}
						// TODO: handle `movewindow`
						case "createworkspacev2": {
							const [idString, name] = args
							const id = Number(idString)
							if (id >= 0) {
								for (const key in workspaceInfos) {
									const info = workspaceInfos[key]
									if (!info) continue
									info.focused = false
									setWorkspaceInfo(info)
								}
							}
							const info = workspaceInfos[name] ?? {}
							info.id = id
							info.name = name
							info.focused = true
							info.exists = true
							setWorkspaceInfo(info)
							break
						}
						case "destroyworkspace": {
							const [name] = args
							const info = workspaceInfos[name]
							if (!info) break
							// info.focused = false
							info.exists = false
							setWorkspaceInfo(info)
							break
						}
					}
				}
			}
		}
	}

	property bool hyprctlErrored: false
	property string queuedCtl: ""
	property string queuedCtlResponse: ""
	property var ctlPromise: Promise.Promise.resolve(null)
	property var resolveCtlPromise: () => {}
	property var rejectCtlPromise: () => {}

	Socket {
		id: hyprctl
		onConnectedChanged: {
			if (connected) {
				write(queuedCtl)
			} else if (!hyprctlErrored) {
				resolveCtlPromise(queuedCtlResponse)
				queuedCtl = ""
				queuedCtlResponse = ""
			}
			hyprctlErrored = false
		}
		path: `/tmp/hypr/${Quickshell.env("HYPRLAND_INSTANCE_SIGNATURE")}/.socket.sock`
		parser: SplitParser {
			splitMarker: ""
			onRead: data => {
				queuedCtlResponse = data
				hyprctl.connected = false
			}
		}
		onError: error => {
			hyprctlErrored = true
			// FIXME: this SHOULD work, but breaks during initialization
			// it's possible that something else is occuping the socket during initialization
			// rejectCtlPromise(error)
			workaround.running = true
		}
	}

	Timer {
		id: workaround
		interval: 100
		onTriggered: hyprctl.connected = true
	}

	function exec(flags, ...args) {
		const ctl = (flags ?? "") + "/" + args.join(" ")
		return ctlPromise = ctlPromise.then(() => new Promise.Promise((resolve, reject) => {
			queuedCtl = ctl
			resolveCtlPromise = resolve
			rejectCtlPromise = reject
			hyprctl.connected = true
		}))
	}

	Component.onCompleted: {
		exec("j", "activewindow").then(json => {
			const data = JSON.parse(json)
			activeWindow.address = data.address.slice(2)
			activeWindow.title = data.title
			activeWindow.klass = data.class
			activeWorkspace.id = data.workspace.id
			activeWorkspace.name = data.workspace.name
		})
		exec("j", "workspaces").then(json => {
			const data = JSON.parse(json)
			for (const datum of data) {
				const info = workspaceInfos[datum.name]
				if (!info) continue
				info.exists = true
				setWorkspaceInfo(info)
			}
		})
		exec("j", "clients").then(json => {
			const data = JSON.parse(json)
			for (const datum of data) {
				const address = datum.address.slice(2)
				const info = windows[address] ?? {}
				info.address = address
				info.klass = datum.class
				info.title = datum.title
				info.initialClass = datum.initialClass
				info.initialTitle = datum.initialTitle
				windows[datum.address] = info
			}
		})
		exec("j", "activeworkspace").then(json => {
			const data = JSON.parse(json)
			const info = workspaceInfos[data.name]
			if (!info) return
			info.focused = true
			setWorkspaceInfo(info)
		})
	}

	function setWorkspaceInfo(info) {
		workspaceInfos[info.name] = info
		if (info.id >= 1 && info.id <= 9) workspaceInfosArray[info.id - 1] = info
	}

	function focusWindow(id) {
		exec(null, "dispatch", "focuswindow", String(id))
	}

	function focusWorkspace(address) {
		exec(null, "dispatch", "workspace", String(address))
	}

	function focusWorkspaceOnCurrentMonitor(id) {
		exec(null, "dispatch", "workspace", String(id))
	}
}
