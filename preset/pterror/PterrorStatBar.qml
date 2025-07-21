import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.io
import qs.component
import qs.widget
import qs

PanelWindow {
	anchors { left: true; right: true; top: true }
	implicitHeight: 32 // TODO[broken]: Config._.style.hBar.height
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
		color: Config._.style.bar.bg
		radius: Config._.style.hBar.radius
		border.color: Config._.style.bar.outline
		border.width: Config._.style.hBar.border

		RowLayout2 {
			implicitHeight: parent.height
			anchors.left: parent.left

			Text2 {
				function n(n) { return String(n).padStart(2, "0") }
				text: " " + n(Time.hour) + ":" + n(Time.minute) + ":" + n(Time.second) + " " + n(Time.time.getDate()) + "/" + n(Time.time.getMonth() + 1)
			}
		}

		RowLayout2 {
			implicitHeight: parent.height
			anchors.centerIn: parent

			Text2 { text: Config.services.compositor.activeWindow.title.normalize("NFKC").toLowerCase() }
		}

		RowLayout2 {
			implicitHeight: parent.height
			anchors.right: parent.right

			TrayStatus {}

			HoverItem {
				onClicked: Config._.workspacesOverview.visible = !Config._.workspacesOverview.visible
				WorkspacesStatus {}
			}
		}
	}
}
