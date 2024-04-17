import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "../io"
import "../component"
import "../widget"
import "../library"
import ".."

PanelWindow {
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

				Text2 {
					Layout.alignment: Qt.AlignLeft
					function n(n) { return String(n).padStart(2, "0") }
					text: n(Time.time.getDate()) + "/" + n(Time.time.getMonth() + 1) + " " +
						n(Time.time.getHours()) + ":" + n(Time.time.getMinutes()) + ":" + n(Time.time.getSeconds())
				}
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
