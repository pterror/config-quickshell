pragma Singleton

import QtQuick
import Quickshell
import "../library/Fetch.mjs" as Fetch

Singleton {
	id: root
	property int interval: 1000
	property real total: 1
	property real idle: 1
	property real active: total - idle
	property real totalSec: 1
	property real idleSec: 1
	property real activeSec: totalSec - idleSec
	property list<var> cpuInfos: []
	property int cpuCount: cpuInfos.length
	signal cpuFractionSec(int cpu, real fraction)

	Timer {
		interval: root.interval; running: true; repeat: true; triggeredOnStart: true
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
					let i = 0
					for (const line of text.match(/cpu(\d+).+/g)) {
						const [id, user, nice, system, newIdle, iowait, irq, softirq, steal, guest, guestNice] = line.match(/\d+/g).map(Number)
						const newTotal = user + nice + system + newIdle + iowait + irq + softirq + steal + guest + guestNice
						while (cpuInfos.length < id) cpuInfos.push({ total: 1, idle: 1, totalSec: 1, idleSec: 1 })
						const info = cpuInfos[id] ?? { total: 1, idle: 1, totalSec: 1, idleSec: 1 }
						info.idleSec = newIdle - info.idle
						info.totalSec = newTotal - info.total
						info.idle = newIdle
						info.total = newTotal
						cpuInfos[id] = info
						root.cpuFractionSec(i, 1 - info.idleSec / info.totalSec)
						i += 1
					}
				})
		}
	}
}
