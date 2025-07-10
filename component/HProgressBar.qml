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
		property int maxWidth: parent.width - root.margins * 2
		anchors {
			left: parent.left
			top: parent.top
			bottom: parent.bottom
			margins: root.margins
		}
		width: maxWidth * Math.max(0, Math.min(1, fraction))
		color: root.fg
		radius: root.innerRadius

		Behavior on width {
			SmoothedAnimation {
				velocity: mouseArea.pressed ? 5000 : animationVelocity
				duration: animationDuration
			}
		}
	}

	MouseArea {
		id: mouseArea
		anchors.fill: parent
		anchors.margins: root.margins
		onPressed: event => root.input(1 - (event.x / width))
		onPositionChanged: event => {
			if (!pressed) return
			root.input(1 - (event.x / width))
		}
	}
}
