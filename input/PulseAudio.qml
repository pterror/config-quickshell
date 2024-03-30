pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
	property bool initialized: volume != -1
	property int volume: -1
	property bool muted: false
	property string updatedSink: "0"
	property string volumeChange: ""
	property string muteChange: ""
	property string micMuteChange: ""

	Process {
		running: true
		command: ["pactl", "list", "sinks"]
		stdout: SplitParser {
			splitMarker: ""
			onRead: data => {
				const match = data.match(/Sink #(\d+)/)
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

	Process {
		id: setVolumeProcess
		command: ["pactl", "set-sink-volume", "@DEFAULT_SINK@", volumeChange + "%"]
	}

	function increaseVolume(n) { volumeChange = "+" + n; setVolumeProcess.running = true }
	function decreaseVolume(n) { volumeChange = "-" + n; setVolumeProcess.running = true }
	function setVolume(n) { volumeChange = String(n); setVolumeProcess.running = true }

	Process {
		id: setMuteProcess
		command: ["pactl", "set-sink-mute", "@DEFAULT_SINK@", muteChange]
	}

	function toggleMute() { muteChange = "toggle"; setMuteProcess.running = true }
	function mute() { muteChange = "1"; setMuteProcess.running = true }
	function unmute() { muteChange = "0"; setMuteProcess.running = true }

	Process {
		id: setMicMuteProcess
		command: ["pactl", "set-source-mute", "@DEFAULT_SINK@", micMuteChange]
	}

	function toggleMicMute() { micMuteChange = "toggle"; setMicMuteProcess.running = true }
	function micMute() { micMuteChange = "1"; setMicMuteProcess.running = true }
	function micUnmute() { micMuteChange = "0"; setMicMuteProcess.running = true }
}
