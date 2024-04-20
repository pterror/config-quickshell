pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import ".."

Singleton {
	property bool playing: false
	property string title: ""
	property string artist: ""
	property string image: "../image/dark_pixel.png"

	Process {
		running: true
		onRunningChanged: running = true
		command: ["playerctl", "-F", "status"]
		stdout: SplitParser {
			onRead: data => playing = data === "Playing"
		}
	}

	Process {
		running: true
		onRunningChanged: running = true
		command: ["playerctl", "-F", "metadata"]
		stdout: SplitParser {
			splitMarker: ""
			onRead: data => {
				if (Config.debug) {
					console.log("MPRIS [stdin]: " + data)
				}
				let newTitle = ""
				let newArtist = ""
				let newImage = "../image/dark_pixel.png"
				for (const line of data.split("\n")) {
					const [, player, key, value] = line.match(/(.+?) +(.+?) +(.+)/) ?? []
					switch (key) {
						case "xesam:title": { newTitle = value; break }
						case "xesam:artist": { newArtist = value; break }
						case "mpris:artUrl": { newImage = value; break }
					}
				}
				title = newTitle 
				artist = newArtist 
				image = newImage
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
