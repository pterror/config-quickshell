pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs
import "root:/library/Units.mjs" as Units

Singleton {
	property string interface_: Config.services.network.interface_ || Config._.network.interface_
	property real upload: 0
	property real download: 0
	property real uploadSec: 0
	property real downloadSec: 0
	property string uploadSecText: Units.bytesToHumanReadable(uploadSec)
	property string downloadSecText: Units.bytesToHumanReadable(downloadSec)

	function sampleInterface(text) {
		if (!text || !interface_)
			return null
		const escaped = interface_.replace(/[.*+?^${}()|[\]\\]/g, "\\$&")
		const match = text.match(new RegExp("^\\s*" + escaped + ":\\s*(.+)$", "m"))
		if (!match)
			return null
		const fields = match[1].trim().split(/\s+/)
		if (fields.length < 16)
			return null
		return {
			download: Number(fields[0]) || 0,
			upload: Number(fields[8]) || 0
		}
	}

	Timer {
		interval: 1000; running: true; repeat: true; triggeredOnStart: true
		onTriggered: {
			file.reload()
			const sample = sampleInterface(file.text())
			if (!sample)
				return
			uploadSec = Math.max(0, sample.upload - upload)
			downloadSec = Math.max(0, sample.download - download)
			upload = sample.upload
			download = sample.download
		}
	}

	FileView { id: file; path: "/proc/net/dev" }
}
