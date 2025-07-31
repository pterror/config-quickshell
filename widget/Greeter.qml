import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import qs
import qs.component
import qs.io

Rectangle {
	id: root
	color: "transparent"
	width: content.implicitWidth
	height: content.implicitHeight

	ColumnLayout {
		id: content
		anchors.horizontalCenter: parent.horizontalCenter
		radius: Config._.style.panel.radius
		margins: Config._.style.panel.margins
		// color: Config._.style.panel.bg
		spacing: 8

		onImplicitWidthChanged: root.width = Math.max(root.width, implicitWidth)

		Text {
			font.pointSize: 64
			color: Config._.style.greeter.fg
			function n(n) { return String(n).padStart(2, "0") }
			text: n(Time.hour) + ":" + n(Time.minute)
		}
		Text {
			font.pointSize: 12
			color: Config._.style.greeter.fg
			text: Time.days[Time.time.getDay()] + ", " + Time.months[Time.time.getMonth()] + " " + Time.time.getDate()
		}
		Text {
			property string period: Time.hour < 12 ?
				(Config._.owo ? "mwowning" : "morning") :
				Time.hour < 18 ?
				(Config._.owo ? "awftewnwoon" : "afternoon") :
				(Config._.owo ? "evwenwing" : "evening")
			font.pointSize: 16
			color: Config._.style.greeter.fg
			text: (Config._.owo ? "Gwood " : "Good ") + period + ", " + Config._.name + "."
		}
	}
}
