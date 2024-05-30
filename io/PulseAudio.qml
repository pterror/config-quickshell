pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import "root:/"

Singleton {
	property bool initialized: volume != -1 && micVolume != -1
	property int volume: -1
	property int micVolume: -1
	property bool muted: false
	property bool micMuted: false
	property string volumeChange: ""
	property string micVolumeChange: ""
	property string muteChange: ""
	property string micMuteChange: ""

	Process {
		running: true
		onRunningChanged: running = true
		command: ["pactl", "subscribe"]
		stdout: SplitParser {
			onRead: data => {
				if (Config.debug) {
					console.log("PulseAudio [stdin]: " + data)
				}
				const [, updatedSink] = data.match(/sink #(\d+)/) ?? []
				if (updatedSink) {
					volumeProcess.running = true
					muteProcess.running = true
					return
				}
				const [, updatedSource] = data.match(/source #(\d+)/) ?? []
				if (updatedSource) {
					micVolumeProcess.running = true
					micMuteProcess.running = true
					return
				}
			}
		}
	}

	Process {
		running: true
		id: volumeProcess
		command: ["pactl", "get-sink-volume", "@DEFAULT_SINK@"]
		stdout: SplitParser {
			splitMarker: ""
			onRead: data => volume = Number(data.match(/(\d+)%/)?.[1] || 0)
		}
	}

	Process {
		running: true
		id: muteProcess
		command: ["pactl", "get-sink-mute", "@DEFAULT_SINK@"]
		stdout: SplitParser { splitMarker: ""; onRead: data => muted = data == "Mute: yes\n" }
	}

	Process {
		running: true
		id: micVolumeProcess
		command: ["pactl", "get-source-volume", "@DEFAULT_SOURCE@"]
		stdout: SplitParser {
			splitMarker: ""
			onRead: data => micVolume = Number(data.match(/(\d+)%/)?.[1] || 0)
		}
	}

	Process {
		running: true
		id: micMuteProcess
		command: ["pactl", "get-source-mute", "@DEFAULT_SOURCE@"]
		stdout: SplitParser { splitMarker: ""; onRead: data => micMuted = data == "Mute: yes\n" }
	}

	Process { id: setVolumeProcess; command: ["pactl", "set-sink-volume", "@DEFAULT_SINK@", volumeChange + "%"] }

	function setVolume(volume: real) { volumeChange = String(volume); setVolumeProcess.running = true }
	function changeVolume(change: real) {
		volumeChange = change > 0 ? "+" + change : "-" + (-change)
		setVolumeProcess.running = true
	}

	Process { id: setMicVolumeProcess; command: ["pactl", "set-source-volume", "@DEFAULT_SOURCE@", micVolumeChange + "%"] }

	function setMicVolume(volume: real) { micVolumeChange = String(volume); setMicVolumeProcess.running = true }
	function changeMicVolume(change: real) {
		micVolumeChange = change > 0 ? "+" + change : "-" + (-change)
		setMicVolumeProcess.running = true
	}

	Process { id: setMuteProcess; command: ["pactl", "set-sink-mute", "@DEFAULT_SINK@", muteChange] }

	function toggleMute() { muteChange = "toggle"; setMuteProcess.running = true }
	function setMuted(muted: bool) { muteChange = muted ? "1" : "0"; setMuteProcess.running = true }

	Process { id: setMicMuteProcess; command: ["pactl", "set-source-mute", "@DEFAULT_SOURCE@", micMuteChange] }

	function toggleMicMute() { micMuteChange = "toggle"; setMicMuteProcess.running = true }
	function setMicMuted(muted: bool) { micMuteChange = muted ? "1" : "0"; setMicMuteProcess.running = true }
}
