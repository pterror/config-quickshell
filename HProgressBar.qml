import Quickshell
import QtQuick

FadingWindow {
	required property real fraction
	anchors.top: true
	color: "transparent"
	width: 240
	height: 56

	Widget {
		anchors { fill: parent; margins: 8 }
		color: Config.colors.panel.bg
		radius: Config.layout.panel.radius

		Rectangle {
			property int maxWidth: parent.width - Config.layout.panel.margins * 2
			anchors {
				left: parent.left
				top: parent.top
				bottom: parent.bottom
				margins: Config.layout.panel.margins
			}
			width: maxWidth * Math.max(0, Math.min(1, fraction))
			color: Config.colors.panel.accent
			radius: Config.layout.panel.innerRadius

			Behavior on height { SmoothedAnimation { velocity: 50 } }
		}
	}
}
