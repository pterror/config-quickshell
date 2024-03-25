pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
	property int volume: 0
	property bool muted: false

	property Process volumeProcess: Process {
		running: true
		command: ["pamixer", "--get-volume"]
		stdout: SplitParser { onRead: data => volume = Number(data) }
	}

	property Process muteProcess: Process {
		running: true
		command: ["pamixer", "--get-mute"]
		stdout: SplitParser { onRead: data => muted = data === "true" }
	}

	Timer {
		interval: 1000; running: true; repeat: true
		onTriggered: {
			volumeProcess.running = true
			muteProcess.running = true
		}
	}
}
