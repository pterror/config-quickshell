import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

PanelWindow {
	id: root
	anchors {
		left: true
		right: true
		bottom: true
	}

	height: Config.layout.topBar.height
	color: "transparent"
	WlrLayershell.namespace: "shell:bar"

	Rectangle {
		id: barRect
		anchors {
			fill: parent
			margins: Config.layout.topBar.margins
		}

		color: Config.colors.bar.bg
		radius: Config.layout.topBar.radius
		border.color: Config.colors.bar.outline
		border.width: Config.layout.topBar.border

		RowLayout {
			anchors.fill: parent
			RowLayout2 {
				Layout.fillHeight: true
				Layout.fillWidth: true

				HSpace {}
				Text2 { text: MPRIS.title + " - " + MPRIS.artist }
				HSpace {}
			}
		}
	}
}
