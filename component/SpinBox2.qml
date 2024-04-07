import QtQuick
import QtQuick.Controls
import ".."

SpinBox {
	id: root
	// FIXME: broken because of `Component` with `source` in `SettingsDynamicItem.qml`
	anchors.margins: Config.layout.hBar.margins
	editable: true
	width: 80
	to: 999
	font.family: Config.font.family
	font.pointSize: Config.layout.widget.fontSize
	contentItem: TextInput {
		color: Config.colors.widget.fg
		font: root.font
		horizontalAlignment: Qt.AlignHCenter
		readOnly: !root.editable
		validator: root.validator
		inputMethodHints: Qt.ImhFormattedNumbersOnly
		text: root.value
	}
	up.indicator: Rectangle {
		anchors.right: parent.right
		anchors.top: parent.top
		height: parent.height / 2
		width: parent.height
		color: root.up.pressed ? Config.colors.widget.bg : "transparent"
		radius: Config.layout.barItem.radius
		Text {
			text: "▴"
			color: Config.colors.widget.fg
			anchors.fill: parent
			fontSizeMode: Text.Fit
			horizontalAlignment: Text.AlignHCenter
			verticalAlignment: Text.AlignVCenter
		}
		MouseArea { // for cursor only
			enabled: false
			anchors.fill: parent
			cursorShape: Qt.PointingHandCursor
		}
		Behavior on color { PropertyAnimation { duration: 100 } }
	}
	down.indicator: Rectangle {
		anchors.right: parent.right
		anchors.bottom: parent.bottom
		height: parent.height / 2
		width: parent.height
		color: root.down.pressed ? Config.colors.widget.bg : "transparent"
		radius: Config.layout.barItem.radius
		Text {
			text: "▾"
			color: Config.colors.widget.fg
			anchors.fill: parent
			fontSizeMode: Text.Fit
			horizontalAlignment: Text.AlignHCenter
			verticalAlignment: Text.AlignVCenter
		}
		MouseArea { // for cursor only
			enabled: false
			anchors.fill: parent
			cursorShape: Qt.PointingHandCursor
		}
		Behavior on color { PropertyAnimation { duration: 100 } }
	}
	background: Rectangle {
		color: Config.colors.widget.bg
		radius: Config.layout.barItem.radius
	}
}
