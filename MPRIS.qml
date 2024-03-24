pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
	property string title: "(unknown)"
	property string artist: "(unknown)"

	property Process titleProcess: Process {
		running: true
		command: ["playerctl", "--player=playerctld", "metadata", "xesam:title"]
		stdout: SplitParser { onRead: data => title = data }
	}

	property Process artistProcess: Process {
		running: true
		command: ["playerctl", "--player=playerctld", "metadata", "xesam:artist"]
		stdout: SplitParser { onRead: data => artist = data }
	}

	Timer {
		interval: 1000; running: true; repeat: true
		onTriggered: {
			titleProcess.running = true
			artistProcess.running = true
		}
	}
}
