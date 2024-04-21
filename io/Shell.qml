pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
	property bool selectingWindowArea: false
	property bool workspacesOverview: false

	SocketServer {
		active: true
		onActiveChanged: active = true
		path: "/run/user/1000/quickshell-shell-ipc.sock"

		handler: Socket {
			parser: SplitParser {
				onRead: message => {
					if (Config.debug) {
						console.log("Shell: " + message)
					}
					switch (message) {
						case "window_selection_area:start": { selectingWindowArea = true; break }
						case "window_selection_area:stop": { selectingWindowArea = false; break }
						case "workspaces_overview:open": { workspacesOverview = true; break }
						case "workspaces_overview:close": { workspacesOverview = false; break }
						case "workspaces_overview:toggle": { workspacesOverview = !workspacesOverview; break }
						default: {
							console.error(`Shell received unknown message: ${message}`)
							break
						}
					}
				}
			}
		}
	}
}
