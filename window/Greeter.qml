import QtQuick
import QtQuick.Layouts
import Quickshell
import "../component"
import "../library"
import ".."

// FIXME:
PanelWindow {
	color: "transparent"
	width: content.implicitWidth
	height: content.implicitHeight

	ColumnLayout2 {
		id: content
		autoSize: true
		radius: Config.layout.panel.radius
		margins: Config.layout.panel.margins
		// color: Config.colors.panel.bg
		spacing: 8

		Text2 {
			font.pointSize: 64
			color: Config.colors.greeter.fg
			function n(n) { return String(n).padStart(2, "0") }
			text: n(Time.time.getHours()) + ":" + n(Time.time.getMinutes())
		}
		Text2 {
			font.pointSize: 12
			color: Config.colors.greeter.fg
			text: Time.days[Time.time.getDay()] + ", " + Time.months[Time.time.getMonth()] + " " + Time.time.getDate()
		}
		Text2 {
			property string period: Time.time.getHours() < 12 ? "morning" : Time.time.getHours() < 18 ? "afternoon" : "evening"
			font.pointSize: 16
			color: Config.colors.greeter.fg
			text: "Good " + period + ", " + Config.name + "."
		}
	}
}
