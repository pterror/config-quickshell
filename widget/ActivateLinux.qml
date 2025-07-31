import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import qs.component
import qs

Rectangle {
	anchors.right: parent.right; anchors.bottom: parent.bottom
	anchors.rightMargin: 50; anchors.bottomMargin: 50
	width: content.implicitWidth
	height: content.implicitHeight
	color: "transparent"

	ColumnLayout {
		id: content

		Text {
			Layout.alignment: Qt.AlignLeft
			color: Config._.style.activateLinux.fg
			font.pointSize: 22
			text: (Config._.owo ? "Actwivwate " : "Activate ") + Config._.activateLinux.name
		}

		Text {
			Layout.alignment: Qt.AlignLeft
			color: Config._.style.activateLinux.fg
			font.pointSize: 14
			text: (Config._.owo ? "Gowo twu Swettwings twu actwivwate " : "Go to Settings to activate ") + Config._.activateLinux.name
		}
	}
}
