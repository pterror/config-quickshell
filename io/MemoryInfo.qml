pragma Singleton

import QtQuick
import Quickshell
import "../library/Fetch.mjs" as Fetch

Singleton {
	property real total: 1
	property real free: 1
	property real used: total - free

	Timer {
		interval: 1000; running: true; repeat: true; triggeredOnStart: true
		onTriggered: {
			Fetch.fetch("file:///proc/meminfo")
				.then(res => res.text())
				.then(text => {
					total = Number(text.match(/MemTotal: *(\d+)/)?.[1] ?? "1")
					free = Number(text.match(/MemAvailable: *(\d+)/)?.[1] ?? "0")
				})
		}
	}
}
