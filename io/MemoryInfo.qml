pragma Singleton

import QtQuick
import Quickshell
import Qti.Filesystem
import "root:/library/XHR.mjs" as XHR

Singleton {
	property real total: 1
	property real free: 1
	property real used: total - free

	Timer {
		interval: 1000; running: true; repeat: true; triggeredOnStart: true
		onTriggered: {
			file.close()
			file.open()
			const text = file.read()
				total = Number(text.match(/MemTotal: *(\d+)/)?.[1] ?? 1)
				free = Number(text.match(/MemAvailable: *(\d+)/)?.[1] ?? 0)
		}
	}

	File { id: file; readable: true; path: "/proc/meminfo" }
}
