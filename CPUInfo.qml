pragma Singleton

import QtQuick
import Quickshell
import "Fetch.mjs" as Fetch

Singleton {
	property real total: 1
	property real idle: 1
	property real active: total - idle
	property real totalSec: 1
	property real idleSec: 1
	property real activeSec: totalSec - idleSec

	Timer {
		interval: 1000; running: true; repeat: true; triggeredOnStart: true
		onTriggered: {
			Fetch.fetch("file:///proc/stat")
				.then(res => res.text())
				.then(text => {
          const cpuAll = text.match(/^.+/)[0]
          const [user, nice, system, newIdle, iowait, irq, softirq, steal, guest, guestNice] = cpuAll.match(/\d+/g).map(Number)
          const newTotal = user + nice + system + newIdle + iowait + irq + softirq + steal + guest + guestNice
	        idleSec = newIdle - idle
          totalSec = newTotal - total
          idle = newIdle
          total = newTotal
				})
		}
	}
}
