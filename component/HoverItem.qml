import QtQuick
import QtQuick.Controls
import "root:/"

Button {
	default property alias content: mouseArea.children
	property bool alias: false
	required property var inner
	id: root
	flat: true
	implicitWidth: inner.implicitWidth + Config.style.barItem.margins * 2
	implicitHeight: inner.implicitHeight + Config.style.barItem.margins * 2
	display: AbstractButton.TextOnly
	background: Rectangle {
		anchors.margins: Config.style.button.margins
		radius: Config.style.button.radius
		color: mouseArea.containsMouse ? Config.style.barItem.hoverBg : Config.style.barItem.bg
	}

	MouseArea {
		id: mouseArea
		hoverEnabled: true
		anchors.fill: parent
		anchors.margins: Config.style.barItem.margins
		cursorShape: Qt.PointingHandCursor
		onClicked: root.clicked()
	}
}
