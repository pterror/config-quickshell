import Quickshell
import QtQuick
import ".."

FadingWindow {
	id: root
	required property real fraction
	signal input(real fraction)
	anchors.right: true
	color: "transparent"
	width: 64
	height: 240

	VProgressBar {
		anchors { fill: parent; margins: 8 }
		fraction: root.fraction
		onInput: fraction => root.input(fraction)
	}
}