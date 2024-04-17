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
	property int defaultSink: 0
	property int defaultSource: 0

	Process {
		running: true
		onRunningChanged: running = true
		command: ["pw-cli", "-m"]
		stdout: SplitParser {
			onRead: data => {
				if (Config.debug) {
					console.log("WirePlumber [stdin]: " + data)
				}
				const [, updatedNodeString] = data.match(/remote .+ node (\d+) changed/) ?? []
				if (!updatedNodeString) return
				const updatedNode = Number(updatedNodeString)
				if (updatedNode === defaultSink) {
					volumeProcess.running = true
					muteProcess.running = true
				} else if (updatedNode === defaultSource) {
					micVolumeProcess.running = true
					micMuteProcess.running = true
				}
			}
		}
	}

	// FIXME: watch for changes to default sink/source id
	Process {
		running: true
		id: defaultSinkProcess
		command: ["wpctl", "inspect", "@DEFAULT_SINK@"]
		stdout: SplitParser {
			splitMarker: ""
			onRead: data => defaultSink = Number(data.match(/^id ([\d]+)/)?.[1] || 0)
		}
	}

	Process {
		running: true
		id: defaultSourceProcess
		command: ["wpctl", "inspect", "@DEFAULT_SOURCE@"]
		stdout: SplitParser {
			splitMarker: ""
			onRead: data => defaultSource = Number(data.match(/^id ([\d]+)/)?.[1] || 0)
		}
	}

	Process {
		running: true
		id: volumeProcess
		command: ["wpctl", "get-volume", "@DEFAULT_SINK@"]
		stdout: SplitParser {
			splitMarker: ""
			onRead: data => volume = Number(data.match(/([\d.]+)/)?.[1] || 0) * 100
		}
	}

	Process {
		running: true
		id: muteProcess
		command: ["wpctl", "get-mute", "@DEFAULT_SINK@"]
		stdout: SplitParser { splitMarker: ""; onRead: data => muted = data == "Mute: yes\n" }
	}

	Process {
		running: true
		id: micVolumeProcess
		command: ["wpctl", "get-volume", "@DEFAULT_SOURCE@"]
		stdout: SplitParser {
			splitMarker: ""
			onRead: data => micVolume = Number(data.match(/([\d.]+)/)?.[1] || 0) * 100
		}
	}

	Process {
		running: true
		id: micMuteProcess
		command: ["wpctl", "get-mute", "@DEFAULT_SOURCE@"]
		stdout: SplitParser { splitMarker: ""; onRead: data => micMuted = data == "Mute: yes\n" }
	}

	Process {
		id: setVolumeProcess
		command: ["wpctl", "set-volume", "@DEFAULT_SINK@", volumeChange]
	}

	function increaseVolume(n) { volumeChange = n + "%+"; setVolumeProcess.running = true }
	function decreaseVolume(n) { volumeChange = n + "%-"; setVolumeProcess.running = true }
	function setVolume(n) { volumeChange = String(n * 0.01); setVolumeProcess.running = true }

	Process {
		id: setMicVolumeProcess
		command: ["wpctl", "set-volume", "@DEFAULT_SOURCE@", micVolumeChange]
	}

	function increaseMicVolume(n) { micVolumeChange = n + "%+"; setMicVolumeProcess.running = true }
	function decreaseMicVolume(n) { micVolumeChange = n + "%-"; setMicVolumeProcess.running = true }
	function setMicVolume(n) { micVolumeChange = String(n * 0.01); setMicVolumeProcess.running = true }

	Process {
		id: setMuteProcess
		command: ["wpctl", "set-mute", "@DEFAULT_SINK@", muteChange]
	}

	function toggleMute() { muteChange = "toggle"; setMuteProcess.running = true }
	function mute() { muteChange = "1"; setMuteProcess.running = true }
	function unmute() { muteChange = "0"; setMuteProcess.running = true }

	Process {
		id: setMicMuteProcess
		command: ["wpctl", "set-mute", "@DEFAULT_SOURCE@", micMuteChange]
	}

	function toggleMicMute() { micMuteChange = "toggle"; setMicMuteProcess.running = true }
	function micMute() { micMuteChange = "1"; setMicMuteProcess.running = true }
	function micUnmute() { micMuteChange = "0"; setMicMuteProcess.running = true }
}
