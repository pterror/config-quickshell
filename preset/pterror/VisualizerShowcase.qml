import QtQuick
import Quickshell
import Quickshell.Wayland

// Standalone runner for VisualizerShowcaseContent:
//   qs -p ~/.config/quickshell/preset/pterror/VisualizerShowcase.qml
//
// The shell also embeds VisualizerShowcaseContent directly, as a popup from
// PterrorStatBar.qml — this file just supplies the top-level window.
ShellRoot {
	PanelWindow {
		id: window
		color: "transparent"
		implicitWidth: 1600
		implicitHeight: 1100
		WlrLayershell.namespace: "visualizer-showcase"

		VisualizerShowcaseContent {
			anchors.fill: parent
			onCloseRequested: Qt.quit()
		}
	}
}
