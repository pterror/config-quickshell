import QtQuick
import qs

Widget {
	id: root
	required property real fraction
	property int animationVelocity: -1
	property int animationDuration: 500
	property string fg: Config._.style.panel.accent
	property int margins: Config._.style.panel.margins
	property int innerRadius: Config._.style.panel.innerRadius
	signal input(real fraction)
	color: Config._.style.panel.bg
	radius: Config._.style.panel.radius

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
				velocity: mouseArea.pressed ? 1000000 : animationVelocity
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
