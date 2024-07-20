pragma Singleton

import QtQuick
import Quickshell
import "root:/library/XHR.mjs" as XHR

Singleton {
	property real total: 1
	property real free: 1
	property real used: total - free

	Timer {
		interval: 1000; running: true; repeat: true; triggeredOnStart: true
		onTriggered: {
			XHR.xhr("file:///proc/meminfo", xhr => {
				const text = xhr.responseText
				total = Number(text.match(/MemTotal: *(\d+)/)?.[1] ?? "1")
				free = Number(text.match(/MemAvailable: *(\d+)/)?.[1] ?? "0")
			})
		}
	}
}
