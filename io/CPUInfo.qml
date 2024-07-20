pragma Singleton

import QtQuick
import Quickshell
import "root:/library/XHR.mjs" as XHR

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

	// api for compatibility with `Cava`
	property list<real> values: Array(cpuCount).fill(0) // 0 <= value <= 1
	property int count: cpuCount

	Timer {
		interval: root.interval; running: true; repeat: true; triggeredOnStart: true
		onTriggered: {
			XHR.xhr("file:///proc/stat", xhr => {
				const text = xhr.responseText
				const cpuAll = text.match(/^.+/)[0]
				const [user, nice, system, newIdle, iowait, irq, softirq, steal, guest, guestNice] = cpuAll.match(/\d+/g).map(Number)
				const newTotal = user + nice + system + newIdle + iowait + irq + softirq + steal + guest + guestNice
				idleSec = newIdle - idle
				totalSec = newTotal - total
				idle = newIdle
				total = newTotal
				let i = 0
				// duplicate and set once to avoid spamming signals
				const newCpuInfos = [...cpuInfos]
				const newValues = [...values]
				for (const line of text.match(/cpu(\d+).+/g)) {
					const [id, user, nice, system, newIdle, iowait, irq, softirq, steal, guest, guestNice] = line.match(/\d+/g).map(Number)
					const newTotal = user + nice + system + newIdle + iowait + irq + softirq + steal + guest + guestNice
					while (newCpuInfos.length < id) newCpuInfos.push({ total: 1, idle: 1, totalSec: 1, idleSec: 1 })
					const info = cpuInfos[id] ?? { total: 1, idle: 1, totalSec: 1, idleSec: 1 }
					info.idleSec = newIdle - info.idle
					info.totalSec = newTotal - info.total
					info.idle = newIdle
					info.total = newTotal
					newCpuInfos[id] = info
					const fraction = 1 - info.idleSec / (info.totalSec || 1)
					root.cpuFractionSec(i, fraction)
					newValues[i] = fraction
					i += 1
				}
				cpuInfos = newCpuInfos
				root.values = newValues
			})
		}
	}
}
