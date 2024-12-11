import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import "root:/component"
import "root:/library"
import "root:/"

Rectangle {
	id: root
	color: "transparent"
	width: content.implicitWidth
	height: content.implicitHeight

	ColumnLayout2 {
		id: content
		autoSize: true
		anchors.horizontalCenter: parent.horizontalCenter
		radius: Config.layout.panel.radius
		margins: Config.layout.panel.margins
		// color: Config.colors.panel.bg
		spacing: 8

		onImplicitWidthChanged: root.width = Math.max(root.width, implicitWidth)

		Text2 {
			font.pointSize: 64
			color: Config.colors.greeter.fg
			function n(n) { return String(n).padStart(2, "0") }
			text: n(Time.hour) + ":" + n(Time.minute)
		}
		Text2 {
			font.pointSize: 12
			color: Config.colors.greeter.fg
			text: Time.days[Time.time.getDay()] + ", " + Time.months[Time.time.getMonth()] + " " + Time.time.getDate()
		}
		Text2 {
			property string period: Time.hour < 12 ?
				(Config.owo ? "mwowning" : "morning") :
				Time.hour < 18 ?
				(Config.owo ? "awftewnwoon" : afternoon) :
				(Config.owo ? "evwenwing" : "evening")
			font.pointSize: 16
			color: Config.colors.greeter.fg
			text: (Config.owo ? "Gwood " : "Good ") + period + ", " + Config.name + "."
		}
	}
}
