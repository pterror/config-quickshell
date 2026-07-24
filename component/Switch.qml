import QtQuick
import QtQuick.Controls as QQC

QQC.Switch {
	id: root

	implicitWidth: 42
	implicitHeight: 24
	padding: 0
	leftPadding: 0
	rightPadding: 0
	topPadding: 0
	bottomPadding: 0
	hoverEnabled: true

	indicator: Rectangle {
		implicitWidth: 42
		implicitHeight: 24
		radius: 12
		color: root.checked ? "#5bb2f7ef" : "#18000000"
		border.width: 1
		border.color: root.checked ? "#80eff7f6" : "#30ffffff"

		Rectangle {
			x: 3 + root.visualPosition * (parent.width - width - 6)
			y: 3
			width: 18
			height: 18
			radius: 9
			color: "#eff7f6"
		}

		MouseArea {
			enabled: false
			anchors.fill: parent
			cursorShape: Qt.PointingHandCursor
		}
	}

	contentItem: Item {}
}
