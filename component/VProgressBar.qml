import QtQuick
import ".."

Widget {
	id: root
	required property real fraction
	property int animationSpeed: -1
	property int animationDuration: 500
	property string fg: Config.colors.panel.accent
	property int margins: Config.layout.panel.margins
	property int innerRadius: Config.layout.panel.innerRadius
	signal input(real fraction)
	color: Config.colors.panel.bg
	radius: Config.layout.panel.radius

	Rectangle {
		property int maxHeight: parent.height - root.margins * 2
		anchors {
			left: parent.left
			right: parent.right
			bottom: parent.bottom
			margins: root.margins
		}
		height: maxHeight * Math.max(0, Math.min(1, fraction))
		color: root.fg
		radius: root.innerRadius

		Behavior on height {
			SmoothedAnimation {
				velocity: mouseArea.pressed ? 1000000 : animationSpeed
				duration: animationDuration
			}
		}
	}

	MouseArea {
		id: mouseArea
		anchors.fill: parent
		anchors.margins: root.margins
		onPressed: event => root.input(1 - (event.y / height))
		onPositionChanged: event => {
			if (!pressed) return
			root.input(1 - (event.y / height))
		}
	}
}
