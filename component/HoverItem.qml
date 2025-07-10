import QtQuick
import QtQuick.Controls
import qs

Button {
	default property alias content: mouseArea.children
	property bool alias: false
	required property var inner
	id: root
	flat: true
	implicitWidth: inner.implicitWidth + Config._.style.barItem.margins * 2
	implicitHeight: inner.implicitHeight + Config._.style.barItem.margins * 2
	display: AbstractButton.TextOnly
	background: Rectangle {
		anchors.margins: Config._.style.button.margins
		radius: Config._.style.button.radius
		color: mouseArea.containsMouse ? Config._.style.barItem.hoverBg : Config._.style.barItem.bg
	}

	scale: mouseArea.pressed && !Config._.reducedMotion ? Config._.style.button.pressedScale : 1
	Behavior on scale { SmoothedAnimation { velocity: Config._.style.button.pressedScaleSpeed } }

	MouseArea {
		id: mouseArea
		hoverEnabled: true
		anchors.fill: parent
		anchors.margins: Config._.style.barItem.margins
		cursorShape: Qt.PointingHandCursor
		onClicked: root.clicked()
	}
}
