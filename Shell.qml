pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
	property bool termSelect: false
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
						case "termselect:start": { termSelect = true; break }
						case "termselect:stop": { termSelect = false; break }
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
