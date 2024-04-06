pragma Singleton

import QtQuick
import Quickshell

Singleton {
	property date time: new Date()
	property int hour: 0
	property int minute: 0
	property int second: 0
	property list<var> days: [
		undefined, "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday",
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
