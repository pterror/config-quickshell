import QtQuick
import QtQuick.Controls
import "root:/"

Button {
	id: root
	required property string source
	property int size: Config.style.iconButton.size
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
	ToolTip.delay: Config.style.tooltip.delay
	ToolTip.timeout: Config.style.tooltip.timeout
	ToolTip.visible: toolTip !== undefined && mouseArea.containsMouse
	ToolTip.text: toolTip ?? ""

	background: Rectangle {
		anchors.margins: Config.style.button.margins
		radius: Config.style.button.radius
		color: mouseArea.containsMouse ? Config.style.button.hoverBg : Config.style.button.bg

		Behavior on color { PropertyAnimation { duration: Config.style.button.animationDuration } }
	}

	MouseArea {
		id: mouseAreaEl
		anchors.fill: parent
		hoverEnabled: true
		cursorShape: Qt.PointingHandCursor
		onClicked: root.clicked()
	}
}