pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
	property bool termSelect: false
	property bool workspacesOverview: false

	SocketServer {
		active: true
		onActiveChanged: active = true
		path: "/run/user/1000/quickshell.sock"

		handler: Socket {
			parser: SplitParser {
				onRead: message => {
					if (Config.debug) {
						console.log("ShellIpc: " + message)
					}
					switch (message) {
						case "termselect:start": { termSelect = true; break }
						case "termselect:stop": { termSelect = false; break }
						case "workspacesoverview:open": { workspacesOverview = true; break }
						case "workspacesoverview:close": { workspacesOverview = false; break }
						case "workspacesoverview:toggle": { workspacesOverview = !workspacesOverview; break }
						default: {
							console.error(`ShellIpc received unknown message: ${message}`)
							break
						}
					}
				}
			}
		}
	}
}
