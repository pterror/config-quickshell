import Quickshell
import Quickshell.Wayland
import QtQuick.Layouts
import "../component"
import ".."

PanelWindow {
	anchors { right: true; bottom: true }
	margins { right: 50; bottom: 50 }
	width: content.implicitWidth
	height: content.implicitHeight
	color: "transparent"
	mask: Region {}
	WlrLayershell.layer: WlrLayer.Overlay

	ColumnLayout2 {
		autoSize: true
		id: content
		Text2 {
			Layout.alignment: Qt.AlignLeft
			color: Config.colors.activateLinux.fg
			font.pointSize: 22
			text: "Activate " + Config.activateLinux.name
		}
		Text2 {
			Layout.alignment: Qt.AlignLeft
			color: Config.colors.activateLinux.fg
			font.pointSize: 14
			text: "Go to Settings to activate " + Config.activateLinux.name
		}
	}
}
