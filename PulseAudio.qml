pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
	property int volume: 0
	property bool muted: false
	property string updatedSink: "0"

	Process {
		running: true
		command: ["pactl", "list", "sinks"]
		stdout: SplitParser {
			splitMarker: ""
			onRead: data => {
				const match = data.match(/Sink #(\d+)/)
				console.log(match)
				if (match) {
					updatedSink = match[1]
					volumeProcess.running = true
					muteProcess.running = true
				}
			}
		}
	}

	Process {
		running: true
		command: ["pactl", "subscribe"]
		stdout: SplitParser {
			onRead: data => {
				const sinkMatch = data.match(/sink #(\d+)/)
				if (sinkMatch) {
					const sinkId = sinkMatch[1]
					volumeProcess.running = true
					muteProcess.running = true
				}
			}
		}
	}

	Process {
		id: volumeProcess
		command: ["pactl", "get-sink-volume", updatedSink]
		stdout: SplitParser {
			splitMarker: ""
			onRead: data => volume = Number(data.match(/(\d+)%/)?.[1] || 0)
		}
	}

	Process {
		id: muteProcess
		command: ["pactl", "get-sink-mute", updatedSink]
		stdout: SplitParser { splitMarker: ""; onRead: data => data == "Mute: yes\n" }
	}
}
