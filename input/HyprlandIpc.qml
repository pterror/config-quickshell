pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick
import ".."

Singleton {
	property string submap: ""
	property string activeMonitor: ""
	property var activeScreen: Quickshell.screens[0]
	property QtObject activeWindow: QtObject {
		property string address: "0"
		property string title: ""
		property string klass: ""
	}
	property list<var> workspaceInfosArray: Array.from({ length: 9 }, (_, i) => {
		return { id: i + 1, name: String(i + 1), focused: false, exists: false }
	})
	property var workspaceInfos: workspaceInfosArray.reduce((p, c) => { p[c.name] = c; return p }, {})
	property QtObject activeWorkspace: QtObject {
		property int id: 1
		property string name: "1"
	}
	property QtObject activeKeyboardLayout: QtObject {
		property string id: "(unknown)"
		property string layout: "(unknown)"
	}

	property string windowToFocus: ""
	property string workspaceToFocus: ""
	property string workspaceToFocusOnCurrentMonitor: ""

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
					console.log("HyprlandIpc: " + message)
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
							if (args[0] === "quickshell:workspacesoverview:toggle") {
								ShellIpc.workspacesOverview = !ShellIpc.workspacesOverview
							}
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
							activeKeyboardLayout.layout = args[1]
							keyboardLayoutChanged(args[0], args[1])
							break
						}
						case "focusedmon": {
							activeMonitor = args[0]
							activeScreen = Quickshell.screens.find(screen => screen.name === args[0])
							monitorFocused(args[0], args[1])
							for (const key in workspaceInfos) {
								const info = workspaceInfos[key]
								info.focused = info.name === args[1]
								setWorkspaceInfo(info)
							}
							break
						}
						// TODO: handle `movewindow`
						case "createworkspacev2": {
							const id = Number(args[0])
							const name = args[1]
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
							const name = Number(args[0])
							const info = workspaceInfos[name]
							if (!info) break
							info.focused = false
							info.exists = false
							setWorkspaceInfo(info)
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
					const info = workspaceInfos[datum.name]
					if (!info) continue
					info.exists = true
					setWorkspaceInfo(info)
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
				const info = workspaceInfos[data.name]
				if (!info) return
				info.focused = true
				setWorkspaceInfo(info)
			}
		}
	}

	function setWorkspaceInfo(info) {
		workspaceInfos[info.name] = info
		if (info.id >= 1 && info.id <= 9) workspaceInfosArray[info.id - 1] = info
	}

	Process {
		id: focusWindowProcess
		command: ["hyprctl", "dispatch", "focuswindow", windowToFocus]
	}

	function focusWindow(id) {
		windowToFocus = String(id)
		focusWindowProcess.running = true
	}

	Process {
		id: focusWorkspaceProcess
		command: ["hyprctl", "dispatch", "workspace", workspaceToFocus]
	}

	function focusWorkspace(address) {
		workspaceToFocus = String(address)
		focusWorkspaceProcess.running = true
	}

	Process {
		id: focusWorkspaceOnCurrentMonitorProcess
		command: ["hyprctl", "dispatch", "workspace", workspaceToFocusOnCurrentMonitor]
	}

	function focusWorkspaceOnCurrentMonitor(id) {
		workspaceToFocusOnCurrentMonitor = String(id)
		focusWorkspaceOnCurrentMonitorProcess.running = true
	}
}
