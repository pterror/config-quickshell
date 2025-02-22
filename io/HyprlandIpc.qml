pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick
import "root:/"

Singleton {
	property string submap: ""
	property string activeMonitor: ""
	property var overlayAddress: undefined
	property bool isOverlaid: overlayAddress !== undefined
	property var activeScreen: Quickshell.screens[0]
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
		path: Quickshell.env("XDG_RUNTIME_DIR") + "/hypr/" + Quickshell.env("HYPRLAND_INSTANCE_SIGNATURE") + "/.socket2.sock"

		parser: SplitParser {
			splitMarker: ""
			onRead: message => {
				if (Config.debug) {
					console.log("Hyprland [stdin]: " + message)
				}
				const lines = message.split(/\n(?=.+>>|$)/)
				for (const line of lines) {
					if (!line) continue
					const [, type, body] = line.match(/(.+)>>([\s\S]*)/)
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
							const [address] = args
							delete windows[address]
							windowClosed(address)
							if (address === overlayAddress) {
								overlayAddress = undefined
							}
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
							keyboardLayoutChanged(keyboard, layout)
							break
						}
						case "focusedmon": {
							const [monitor, workspace] = args
							activeMonitor = monitor
							activeScreen = Quickshell.screens.find(screen => screen.name === monitor)
							monitorFocused(monitor, workspace)
							for (const key in workspaceInfos) {
								const info = workspaceInfos[key]
								if (!info) break
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
							info.exists = false
							setWorkspaceInfo(info)
							break
						}
					}
				}
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
		path: Quickshell.env("XDG_RUNTIME_DIR") + "/hypr/" + Quickshell.env("HYPRLAND_INSTANCE_SIGNATURE") + "/.socket.sock"
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
			const data = JSON.parse(json)
			activeWindow.address = data.address.slice(2)
			activeWindow.title = data.title
			activeWindow.klass = data.class
			activeWorkspace.id = data.workspace.id
			activeWorkspace.name = data.workspace.name
		})
		exec("j", ["workspaces"], json => {
			const data = JSON.parse(json)
			for (const datum of data) {
				const info = workspaceInfos[datum.name]
				if (!info) continue
				info.exists = true
				setWorkspaceInfo(info)
			}
		})
		exec("j", ["clients"], json => {
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
		exec("j", ["activeworkspace"], json => {
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
		exec(null, ["dispatch", "focuswindow", String(id)])
	}

	function focusWorkspace(address) {
		exec(null, ["dispatch", "workspace", String(address)])
	}

	function focusWorkspaceOnCurrentMonitor(id) {
		exec(null, ["dispatch", "workspace", String(id)])
	}
}
