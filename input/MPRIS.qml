pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
	property bool playing: false
	property string title: ""
	property string artist: ""
	property string image: "blank.png"

	Process {
		running: true
		command: ["playerctl", "-F", "status"]
		stdout: SplitParser {
			onRead: data => playing = data === "Playing"
		}
	}

	Process {
		running: true
		command: ["playerctl", "-F", "metadata"]
		stdout: SplitParser {
			onRead: data => {
				const [, player, key, value] = data.match(/(.+?) +(.+?) +(.+)/) ?? []
				switch (key) {
					case "xesam:title": { title = value; break }
					case "xesam:artist": { artist = value; break }
					case "mpris:artUrl": { image = value; break }
				}
			}
		}
	}

	Process { id: playProcess; command: ["playerctl", "play"] }
	function play() { playProcess.running = true }

	Process { id: pauseProcess; command: ["playerctl", "pause"] }
	function pause() { pauseProcess.running = true }

	Process { id: playPauseProcess; command: ["playerctl", "play-pause"] }
	function playPause() { playPauseProcess.running = true }

	Process { id: stopProcess; command: ["playerctl", "stop"] }
	function stop() { stopProcess.running = true }

	Process { id: nextProcess; command: ["playerctl", "next"] }
	function next() { nextProcess.running = true }

	Process { id: previousProcess; command: ["playerctl", "previous"] }
	function previous() { previousProcess.running = true }
}
