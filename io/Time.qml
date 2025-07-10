pragma Singleton

import QtQuick
import Quickshell

Singleton {
	property date rawTime: new Date()
	property int rawHour: rawTime.getHours()
	property int rawMinute: rawTime.getMinutes()
	property int rawSecond: rawTime.getSeconds()
	property date time: new Date()
	property real timeDelta: 0
	property int hour: time.getHours()
	property int minute: time.getMinutes()
	property int second: time.getSeconds()
	property list<var> days: [
		"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday",
	]
	property list<string> months: [
		"January", "February", "March", "April", "May", "June",
		"July", "August", "September", "October", "November", "December",
	]

	Timer {
		interval: 1000; running: true; repeat: true
		onTriggered: {
			rawTime = new Date()
			time = timeDelta === 0 ? rawTime : new Date(Number(rawTime) + timeDelta)
		}
	}

	Timer {
		interval: 500; running: true; repeat: true
		onTriggered: refreshDate()
	}

	onTimeDeltaChanged: {
		refreshDate()
		time = timeDelta === 0 ? new Date() : new Date(Number(new Date()) + timeDelta)
	}

	function refreshDate() {
		const date = timeDelta === 0 ? new Date() : new Date(Number(new Date()) + timeDelta)
		hour = date.getHours()
		minute = date.getMinutes()
		second = date.getSeconds()
	}
}
