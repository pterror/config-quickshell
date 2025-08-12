pragma Singleton

import QtQuick
import Quickshell

Singleton {
	property SystemClock clock: SystemClock { id: clock; precision: SystemClock.Seconds }
	property alias rawTime: clock.date
	property alias precision: clock.precision
	property date time: new Date(Number(clock.date) + timeDelta)
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
}
