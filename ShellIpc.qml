pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
	property bool termSelect: false;

	SocketServer {
		active: true
		path: "/run/user/1000/quickshell.sock"

		handler: Socket {
			parser: SplitParser {
				onRead: message => {
					console.log(message)
					switch (message) {
					case "termselect:start":
						termSelect = true;
						break;
					case "termselect:stop":
						termSelect = false;
						break;
					default:
						console.log(`socket received unknown message: ${message}`)
					}
				}
			}
		}
	}
}
