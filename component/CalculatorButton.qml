import QtQuick
import qs

Rectangle {
	id: root

	property alias text: label.text
	property bool emphasize: false
	property bool operatorButton: false
	signal clicked()

	implicitWidth: 48
	implicitHeight: 40
	radius: Config._.style.button.radius
	color: emphasize
		? Config._.style.panel.accent
		: (buttonArea.pressed
			? Config._.style.button.hoverBg
			: (operatorButton
				? Config._.style.panel.bg
				: (buttonArea.containsMouse ? Config._.style.button.hoverBg : Config._.style.button.bg)))
	border.color: emphasize ? Config._.style.panel.accent : Config._.style.button.outline
	border.width: Config._.style.button.border

	Text {
		id: label
		anchors.centerIn: parent
		color: emphasize ? Config._.style.panel.bg : Config._.style.button.fg
		font.family: Config._.font.family
		font.pointSize: Config._.style.widget.fontSize + 1
	}

	MouseArea {
		id: buttonArea
		anchors.fill: parent
		hoverEnabled: true
		cursorShape: Qt.PointingHandCursor
		onClicked: root.clicked()
	}
}
