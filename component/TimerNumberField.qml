import QtQuick
import qs

Rectangle {
	id: root

	property int value: 0
	property int max: 99
	signal valueEdited(int v)

	implicitWidth: 32
	implicitHeight: 24
	radius: Config._.style.widget.radius
	color: Config._.style.widget.bg
	border.color: Config._.style.widget.outline
	border.width: Config._.style.widget.border

	TextInput {
		anchors.fill: parent
		horizontalAlignment: Text.AlignHCenter
		verticalAlignment: Text.AlignVCenter
		color: Config._.style.widget.fg
		font.family: Config._.font.family
		font.pointSize: Config._.style.widget.fontSize
		text: String(root.value).padStart(2, "0")
		validator: IntValidator { bottom: 0; top: root.max }
		selectByMouse: true
		onEditingFinished: root.valueEdited(Math.min(root.max, Math.max(0, Number(text) || 0)))
	}
}
