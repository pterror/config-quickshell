import QtQuick
import ".."

Widget {
	id: root
	required property real fraction
	signal input(real fraction)
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

		Behavior on height { SmoothedAnimation { velocity: mouseArea.pressed ? 5000 : 50 } }
	}

	MouseArea {
		id: mouseArea
		anchors.fill: parent
		anchors.margins: Config.layout.panel.margins
		onPressed: event => root.input(1 - (event.y / height))
		onPositionChanged: event => {
			if (!pressed) return
			root.input(1 - (event.y / height))
		}
	}
}
