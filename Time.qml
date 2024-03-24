pragma Singleton

import QtQuick
import Quickshell

Singleton {
	property date time: new Date()
	property int hour: 0
	property int minute: 0
	property int second: 0

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
