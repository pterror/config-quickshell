import QtQuick
import QtQuick.Controls
import qs

Button {
	id: root
	required property string source
	property int size: Config._.style.iconButton.size
	property int maxSize: size
	readonly property bool hovered_: mouseArea.containsMouse
	property var toolTip: undefined
	property MouseArea mouseArea: mouseAreaEl
	flat: true
	display: AbstractButton.IconOnly
	width: size
	height: size
	icon.width: maxSize
	icon.height: maxSize
	icon.source: source
	ToolTip.delay: Config._.style.tooltip.delay
	ToolTip.timeout: Config._.style.tooltip.timeout
	ToolTip.visible: toolTip !== undefined && mouseArea.containsMouse
	ToolTip.text: toolTip ?? ""

	scale: mouseArea.pressed && !Config._.reducedMotion ? Config._.style.button.pressedScale : 1
	Behavior on scale { SmoothedAnimation { velocity: Config._.style.button.pressedScaleSpeed } }

	background: Rectangle {
		anchors.margins: Config._.style.button.margins
		radius: Config._.style.button.radius
		color: mouseArea.containsMouse ? Config._.style.button.hoverBg : Config._.style.button.bg

		Behavior on color { PropertyAnimation { duration: Config._.style.button.animationDuration } }
	}

	MouseArea {
		id: mouseAreaEl
		anchors.fill: parent
		hoverEnabled: true
		cursorShape: Qt.PointingHandCursor
		onClicked: root.clicked()
	}
}