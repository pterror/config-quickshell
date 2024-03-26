import Quickshell
import QtQuick

FadingWindow {
	required property real fraction
	anchors {
		top: true
	}
	color: "transparent"
	width: 240
	height: 56

	Rectangle {
		anchors {
			fill: parent
			margins: 8
		}

		color: "transparent"

		Widget {
			anchors.fill: parent
			color: Config.colors.panel.bg
			radius: Config.layout.panel.radius

			Rectangle {
				anchors {
					left: parent.left
					top: parent.top
					bottom: parent.bottom
					margins: Config.layout.panel.margins
				}
				width: parent.width * fraction
				color: Config.colors.panel.accent
				radius: Config.layout.panel.innerRadius

				Behavior on width {
					SmoothedAnimation { velocity: 100 }
				}
			}
		}
	}
}
