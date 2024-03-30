import Quickshell
import QtQuick
import ".."

FadingWindow {
	id: root
	required property real fraction
	anchors.right: true
	color: "transparent"
	width: 56
	height: 240

	VProgressBar {
		anchors { fill: parent; margins: 8 }
		fraction: root.fraction
	}
}
