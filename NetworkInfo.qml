pragma Singleton

import QtQuick
import Quickshell
import "Units.mjs" as Units
import "Fetch.mjs" as Fetch

Singleton {
	property real upload: 0
	property real download: 0
	property real uploadSec: 0
	property real downloadSec: 0
	property string uploadSecText: Units.bytesToHumanReadable(uploadSec)
	property string downloadSecText: Units.bytesToHumanReadable(downloadSec)

	Timer {
		interval: 1000; running: true; repeat: true; triggeredOnStart: true
		onTriggered: {
			Fetch.fetch("file:///proc/net/dev")
				.then(res => res.text())
				.then(text => {
					const match = text.match(/wlan0: +(\d+) +\d+ +\d+ +\d+ +\d+ +\d+ +\d+ +\d+ +(\d+)/)
					if (match) {
						const newUpload = Number(match[1])
						const newDownload = Number(match[2])
						uploadSec = newUpload - upload
						downloadSec = newDownload - download
						upload = newUpload
						download = newDownload
					}
				})
		}
	}
}
