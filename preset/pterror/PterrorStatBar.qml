import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "../../io"
import "../../component"
import "../../widget"
import "../../library"
import "../.."

PanelWindow {
	visible: !Hyprland.isOverlaid
	anchors { left: true; right: true; top: true }
	height: Config.layout.hBar.height
	color: "transparent"
	WlrLayershell.namespace: "shell:bar"

	Rectangle {
		id: barRect
		anchors.fill: parent

		color: Config.colors.bar.bg
		radius: Config.layout.hBar.radius
		border.color: Config.colors.bar.outline
		border.width: Config.layout.hBar.border

		RowLayout {
			anchors.fill: parent
			RowLayout2 {
				Layout.fillHeight: true
				width: 400
			}
			RowLayout2 {
				Layout.fillHeight: true
				Layout.fillWidth: true

				Text2 { text: Hyprland.activeWindow.title }
			}
			RowLayout2 {
				Layout.fillHeight: true
				autoSize: true
				implicitWidth: 400

				HSpace {}
				HoverItem {
					inner: workspacesStatus
					onClicked: Shell.workspacesOverview = !Shell.workspacesOverview
					WorkspacesStatus { id: workspacesStatus }
				}
			}
		}
	}
}
