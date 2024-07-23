import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "root:/io"
import "root:/component"
import "root:/widget"
import "root:/library"
import "root:/"

PanelWindow {
	anchors { left: true; right: true; top: true }
	height: Config.layout.hBar.height
	color: "transparent"
	WlrLayershell.layer: WlrLayer.Bottom
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
					function n(n) { return String(n).padStart(2, "0") }
					text: " " + n(Time.hour) + ":" + n(Time.minute) + ":" + n(Time.second) + " " + n(Time.time.getDate()) + "/" + n(Time.time.getMonth() + 1)
				}
				HSpace {}
			}
			RowLayout2 {
				Layout.fillHeight: true
				Layout.fillWidth: true

				Text2 { text: HyprlandIpc.activeWindow.title }
			}
			RowLayout2 {
				Layout.fillHeight: true
				autoSize: true
				implicitWidth: 400

				HSpace {}
				HoverItem {
					inner: workspacesStatus
					onClicked: Config.workspacesOverview.visible = !Config.workspacesOverview.visible
					WorkspacesStatus { id: workspacesStatus }
				}
			}
		}
	}
}
