pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import ".."

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

	Process {
		id: setVolumeProcess
		command: ["pactl", "set-sink-volume", "@DEFAULT_SINK@", volumeChange + "%"]
	}

	function increaseVolume(n) { volumeChange = "+" + n; setVolumeProcess.running = true }
	function decreaseVolume(n) { volumeChange = "-" + n; setVolumeProcess.running = true }
	function setVolume(n) { volumeChange = String(n); setVolumeProcess.running = true }

	Process {
		id: setMicVolumeProcess
		command: ["pactl", "set-source-volume", "@DEFAULT_SOURCE@", micVolumeChange + "%"]
	}

	function increaseMicVolume(n) { micVolumeChange = "+" + n; setMicVolumeProcess.running = true }
	function decreaseMicVolume(n) { micVolumeChange = "-" + n; setMicVolumeProcess.running = true }
	function setMicVolume(n) { micVolumeChange = String(n); setMicVolumeProcess.running = true }

	Process {
		id: setMuteProcess
		command: ["pactl", "set-sink-mute", "@DEFAULT_SINK@", muteChange]
	}

	function toggleMute() { muteChange = "toggle"; setMuteProcess.running = true }
	function mute() { muteChange = "1"; setMuteProcess.running = true }
	function unmute() { muteChange = "0"; setMuteProcess.running = true }

	Process {
		id: setMicMuteProcess
		command: ["pactl", "set-source-mute", "@DEFAULT_SOURCE@", micMuteChange]
	}

	function toggleMicMute() { micMuteChange = "toggle"; setMicMuteProcess.running = true }
	function micMute() { micMuteChange = "1"; setMicMuteProcess.running = true }
	function micUnmute() { micMuteChange = "0"; setMicMuteProcess.running = true }
}
