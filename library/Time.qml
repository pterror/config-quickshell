pragma Singleton

import QtQuick
import Quickshell

Singleton {
	property date time: new Date()
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
		onTriggered: time = new Date()
	}

	Timer {
		interval: 500; running: true; repeat: true
		onTriggered: {
			const date = new Date()
			hour = date.getHours()
			minute = date.getMinutes()
			second = date.getSeconds()
		}
	}
}
