pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
	id: root
	property int interval: 1000
	property real total: 0
	property real idle: 0
	property real iowaitCum: 0
	property real active: total - idle
	property real totalSec: 1
	property real idleSec: 1
	property real iowaitSec: 0
	property real activeSec: totalSec - idleSec
	property real iowaitFraction: iowaitSec / (totalSec || 1)
	property list<var> cpuInfos: []
	property int cpuCount: cpuInfos.length
	signal cpuFractionSec(int cpu, real fraction)

	// api for compatibility with `Cava`
	property list<real> values: Array(cpuCount).fill(0) // 0 <= value <= 1
	property list<real> iowaitValues: Array(cpuCount).fill(0) // 0 <= value <= 1, iowait fraction per cpu
	property int count: cpuCount

	Timer {
		interval: root.interval; running: true; repeat: true; triggeredOnStart: true
		onTriggered: {
			file.reload()
			const text = file.text()
			if (!text) { return }
			const cpuAll = text.match(/^.+/)[0]
			const [user, nice, system, newIdle, iowait, irq, softirq, steal, guest, guestNice] = cpuAll.match(/\d+/g).map(Number)
			const newTotal = user + nice + system + newIdle + iowait + irq + softirq + steal
			const newIdleEffective = newIdle + iowait
			idleSec = newIdleEffective - idle
			totalSec = newTotal - total
			iowaitSec = iowait - iowaitCum
			idle = newIdleEffective
			total = newTotal
			iowaitCum = iowait
			let i = 0
			// duplicate and set once to avoid spamming signals
			const newCpuInfos = [...cpuInfos]
			const newValues = [...values]
			const newIowaitValues = [...iowaitValues]
			for (const line of text.match(/cpu(\d+).+/g)) {
				const [id, user, nice, system, newIdle, iowait, irq, softirq, steal, guest, guestNice] = line.match(/\d+/g).map(Number)
				const newTotal = user + nice + system + newIdle + iowait + irq + softirq + steal
				const newIdleEffective = newIdle + iowait
				while (newCpuInfos.length <= id) newCpuInfos.push({ total: 0, idle: 0, totalSec: 0, idleSec: 0, iowaitCum: 0, iowaitSec: 0 })
				const info = cpuInfos[id] ?? { total: 0, idle: 0, totalSec: 0, idleSec: 0, iowaitCum: 0, iowaitSec: 0 }
				info.idleSec = newIdleEffective - info.idle
				info.totalSec = newTotal - info.total
				info.iowaitSec = iowait - info.iowaitCum
				info.idle = newIdleEffective
				info.total = newTotal
				info.iowaitCum = iowait
				newCpuInfos[id] = info
				const fraction = 1 - info.idleSec / (info.totalSec || 1)
				const iowaitFraction = info.iowaitSec / (info.totalSec || 1)
				root.cpuFractionSec(i, fraction)
				newValues[i] = fraction
				newIowaitValues[i] = iowaitFraction
				i += 1
			}
			cpuInfos = newCpuInfos
			root.values = newValues
			root.iowaitValues = newIowaitValues
		}
	}

	FileView { id: file; path: "/proc/stat" }
}
