import Quickshell
import QtQuick
import ".."

FadingWindow {
	id: root
	required property real fraction
	anchors.top: true
	color: "transparent"
	width: 240
	height: 56

	HProgressBar {
		anchors { fill: parent; margins: 8 }
		fraction: root.fraction
	}
}
