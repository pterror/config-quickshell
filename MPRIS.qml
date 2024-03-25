pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
	property string title: ""
	property string artist: ""
	property string nextTitle: ""
	property string nextArtist: ""

	property Process process: Process {
		running: true
		command: ["playerctl", "--player=playerctld", "metadata"]
		onStarted: { nextTitle = ""; nextArtist = "" }
		onExited: { title = nextTitle; artist = nextArtist }
		stdout: SplitParser {
			onRead: data => {
				const [, player, key, value] = data.match(/(.+?) +(.+?) +(.+)/) ?? []
				switch (key) {
					case "xesam:title": { nextTitle = value; break }
					case "xesam:artist": { nextArtist = value; break }
				}
			}
		}
	}

	Timer {
		interval: 1000; running: true; repeat: true
		onTriggered: process.running = true
	}
}
