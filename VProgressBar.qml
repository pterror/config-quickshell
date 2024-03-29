import Quickshell
import QtQuick

FadingWindow {
	required property real fraction
	anchors.right: true
	color: "transparent"
	width: 56
	height: 240

	Widget {
		anchors { fill: parent; margins: 8 }
		color: Config.colors.panel.bg
		radius: Config.layout.panel.radius

		Rectangle {
			property int maxHeight: parent.height - Config.layout.panel.margins * 2
			anchors {
				left: parent.left
				right: parent.right
				bottom: parent.bottom
				margins: Config.layout.panel.margins
			}
			height: maxHeight * Math.max(0, Math.min(1, fraction))
			color: Config.colors.panel.accent
			radius: Config.layout.panel.innerRadius

			Behavior on height { SmoothedAnimation { velocity: 50 } }
		}
	}
}
