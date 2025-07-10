pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs
import "root:/library/Units.mjs" as Units

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
			file.reload()
			const text = file.text()
			const match = text.match(new RegExp(Config._.network.interface_ + /: +(\d+) +\d+ +\d+ +\d+ +\d+ +\d+ +\d+ +\d+ +(\d+)/.source))
			if (match) {
				const newUpload = Number(match[1])
				const newDownload = Number(match[2])
				uploadSec = newUpload - upload
				downloadSec = newDownload - download
				upload = newUpload
				download = newDownload
			}
		}
	}

	FileView { id: file; path: "/proc/net/dev" }
}
