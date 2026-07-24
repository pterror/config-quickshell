import QtQuick
import qs

Rectangle {
	id: root

	property alias text: label.text
	property bool active: false
	signal clicked()

	implicitWidth: label.implicitWidth + Config._.style.button.margins * 4
	implicitHeight: label.implicitHeight + Config._.style.button.margins * 2
	radius: Config._.style.button.radius
	color: active ? Config._.style.panel.accent : (toggleArea.containsMouse ? Config._.style.button.hoverBg : Config._.style.button.bg)
	border.color: Config._.style.button.outline
	border.width: Config._.style.button.border

	Text {
		id: label
		anchors.centerIn: parent
		color: Config._.style.button.fg
		font.family: Config._.font.family
		font.pointSize: Config._.style.widget.fontSize
	}

	MouseArea {
		id: toggleArea
		anchors.fill: parent
		hoverEnabled: true
		cursorShape: Qt.PointingHandCursor
		onClicked: root.clicked()
	}
}
