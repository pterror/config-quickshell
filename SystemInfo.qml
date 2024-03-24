pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
	property string os: ""
	property string arch: ""
	property string osVersion: ""
	property string osBuildId: ""
	property string username: ""
	property string hostname: ""
	// NOTE: Only works for Linux
	readonly property string desktop: Quickshell.env("XDG_CURRENT_DESKTOP")

	Process {
		running: true
		command: ["whoami"]
		stdout: SplitParser { onRead: data => username = data }
	}

	Process {
		running: true
		command: ["uname", "-s"]
		stdout: SplitParser { onRead: data => os = data }
	}

	Process {
		running: true
		command: ["uname", "-r"]
		stdout: SplitParser { onRead: data => osVersion = data }
	}

	Process {
		running: true
		command: ["uname", "-v"]
		stdout: SplitParser { onRead: data => osBuildId = data }
	}

	Process {
		running: true
		command: ["uname", "-m"]
		stdout: SplitParser { onRead: data => arch = data }
	}

	Process {
		running: true
		command: ["uname", "-n"]
		stdout: SplitParser { onRead: data => hostname = data }
	}
}