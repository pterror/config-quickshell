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
	implicitHeight: 32 // TODO[broken]: Config.style.hBar.height
	color: "transparent"
	Component.onCompleted: {
		if (this.WlrLayershell) {
			this.WlrLayershell.layer = WlrLayer.Bottom
			this.WlrLayershell.namespace = "shell:bar"
		}
	}

	Rectangle {
		id: barRect
		anchors.fill: parent

		color: Config.style.bar.bg
		radius: Config.style.hBar.radius
		border.color: Config.style.bar.outline
		border.width: Config.style.hBar.border

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

				Text2 { text: HyprlandIpc.activeWindow.title.normalize("NFKC").toLowerCase() }
			}
			RowLayout2 {
				Layout.fillHeight: true
				autoSize: true
				implicitWidth: 400

				HSpace {}
				// Tray {}
				HoverItem {
					inner: workspacesStatus
					onClicked: Config.workspacesOverview.visible = !Config.workspacesOverview.visible
					WorkspacesStatus { id: workspacesStatus }
				}
			}
		}
	}
}
