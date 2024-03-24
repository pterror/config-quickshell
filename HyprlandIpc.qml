pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
	property string submap: ""
	property QtObject activeWindow: QtObject {
		property string address: "(unknown)"
		property string title: "(unknown)"
		property string klass: "(unknown)"
	}
	property QtObject activeKeyboardLayout: QtObject {
		property string id: "(unknown)"
		property string layout: "(unknown)"
	}
	signal configReloaded()
	signal windowOpened(address: string, workspace: string, klass: string, title: string)
	signal windowClosed(address: string)
	signal windowFocused(klass: string, title: string)
	signal monitorFocused(name: string, workspace: string)
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
							monitorFocused(args[0], args[1])
							break
						}
					}
				} else {
					console.log("error: malformed message: " + message)
				}
			}
		}
	}
}
