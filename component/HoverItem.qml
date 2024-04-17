import QtQuick
import QtQuick.Controls
import ".."

Button {
	default property alias content: mouseArea.children
	property bool alias: false
	required property var inner
	id: root
	flat: true
	implicitWidth: inner.implicitWidth + Config.layout.barItem.margins * 2
	implicitHeight: inner.implicitHeight + Config.layout.barItem.margins * 2
	display: AbstractButton.TextOnly
	background: Rectangle {
		anchors.margins: Config.layout.button.margins
		radius: Config.layout.button.radius
		color: root.hovered ? Config.colors.barItem.hoverBg : Config.colors.barItem.bg
	}

	MouseArea {
		id: mouseArea
		anchors.fill: parent
		anchors.margins: Config.layout.barItem.margins
		cursorShape: Qt.PointingHandCursor
		onClicked: root.clicked()
	}
}
