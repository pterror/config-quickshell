pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
	property string network: ""
	property string nextNetwork: ""

	property Process process: Process {
		running: true
		command: ["connmanctl", "services"]
		onStarted: nextNetwork = ""
		onExited: network = nextNetwork
		stdout: SplitParser {
			onRead: data => {
				const match = data.match(/^\*A[OR] (\S+)/)
				if (match?.[1]) {
					nextNetwork = match[1]
				}
			}
		}
	}

	Timer {
		interval: 1000; running: true; repeat: true
		onTriggered: process.running = true
	}
}
