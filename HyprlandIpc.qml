pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
	property string submap: ""
	property string activeMonitor: ""
	property var activeScreen: Quickshell.screens[0]
	property QtObject activeWindow: QtObject {
		property string address: "0"
		property string title: ""
		property string klass: ""
	}
	// The first element is always `undefined`, because workspaces are 1-indexed.
	property list<var> workspaceInfos: Array.from({ length: 9 }, (_, i) => {
		return { id: i + 1, name: String(i + 1), focused: false, exists: false }
	})
	property QtObject activeWorkspace: QtObject {
		property int id: 1
		property string name: "1"
	}
	property QtObject activeKeyboardLayout: QtObject {
		property string id: "(unknown)"
		property string layout: "(unknown)"
	}
	signal configReloaded()
	signal windowOpened(address: string, workspace: string, klass: string, title: string)
	signal windowClosed(address: string)
	signal windowFocused(klass: string, title: string)
	signal monitorFocused(name: string, workspaceName: string)
	signal keyboardLayoutChanged(id: string, layout: string)

	Socket {
		connected: true
		path: `/tmp/hypr/${Quickshell.env("HYPRLAND_INSTANCE_SIGNATURE")}/.socket2.sock`

		parser: SplitParser {
			onRead: message => {
				if (Config.debug) {
					console.log("hyprland: " + message)
				}
				const [type, body] = message.split(">>")
				if (body !== undefined) {
					const args = body.split(",")
					switch (type) {
						case "configreloaded": {
							configReloaded()
							break
						}
						case "submap": {
							submap = args[0]
							break
						}
						case "openwindow": {
							windowOpened(args[0], args[1], args[2], args[3])
							break
						}
						case "closewindow": {
							windowClosed(args[0])
							break
						}
						// TODO: What does `windowtitle` do?
						case "activewindow": {
							activeWindow.klass = args[0]
							activeWindow.title = args[1]
							windowFocused(args[0], args[1])
							break
						}
						case "activewindowv2": {
							activeWindow.address = args[0]
							break
						}
						case "activelayout": {
							activeKeyboardLayout.id = args[0]
							activeKeyboardLayout.name = args[1]
							keyboardLayoutChanged(args[0], args[1])
							break
						}
						case "focusedmon": {
							activeMonitor = args[0]
							activeScreen = Quickshell.screens.find(screen => screen.name === args[0])
							monitorFocused(args[0], args[1])
							for (let i = 0; i < 9; i += 1) {
								const info = workspaceInfos[i]
								info.focused = info.name === args[1]
								workspaceInfos[i] = info
							}
							break
						}
						// TODO: handle `movewindow`
						case "createworkspacev2": {
							const id = Number(args[0])
							for (let i = 0; i < 9; i += 1) {
								const info = workspaceInfos[i]
								info.focused = false
								workspaceInfos[i] = info
							}
							const info = workspaceInfos[id - 1]
							info.id = id
							info.name = args[1]
							info.focused = true
							info.exists = true
							workspaceInfos[id - 1] = info
							break
						}
						case "destroyworkspace": {
							const info = workspaceInfos[Number(args[0]) - 1]
							info.focused = false
							info.exists = false
							workspaceInfos[Number(args[0]) - 1] = info
							break
						}
					}
				} else {
					console.log("error: malformed message: " + message)
				}
			}
		}
	}

	Process {
		running: true
		command: ["hyprctl", "activewindow", "-j"]
		stdout: SplitParser {
			splitMarker: ""
			onRead: json => {
				const data = JSON.parse(json)
				activeWindow.address = data.address.slice(2)
				activeWindow.title = data.title
				activeWindow.klass = data.class
				activeWorkspace.id = data.workspace.id
				activeWorkspace.name = data.workspace.name
			}
		}
	}

	Process {
		running: true
		command: ["hyprctl", "workspaces", "-j"]
		stdout: SplitParser {
			splitMarker: ""
			onRead: json => {
				const data = JSON.parse(json)
				for (const datum of data) {
					const info = workspaceInfos[datum.id - 1]
					info.name = datum.name
					info.exists = true
					workspaceInfos[datum.id - 1] = info
				}
			}
		}
	}

	Process {
		running: true
		command: ["hyprctl", "activeworkspace", "-j"]
		stdout: SplitParser {
			splitMarker: ""
			onRead: json => {
				const data = JSON.parse(json)
				const info = workspaceInfos[data.id - 1]
				info.focused = true
				workspaceInfos[data.id - 1] = info
			}
		}
	}
}
