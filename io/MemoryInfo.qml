pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import "root:/library/XHR.mjs" as XHR

Singleton {
	property real total: 1
	property real free: 1
	property real used: total - free

	Timer {
		interval: 1000; running: true; repeat: true; triggeredOnStart: true
		onTriggered: {
			file.reload()
			const text = file.text()
			total = Number(text.match(/MemTotal: *(\d+)/)?.[1] ?? 1)
			free = Number(text.match(/MemAvailable: *(\d+)/)?.[1] ?? 0)
		}
	}

	FileView { id: file; path: "/proc/meminfo" }
}
