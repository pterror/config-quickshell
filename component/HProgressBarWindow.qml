import Quickshell
import QtQuick
import ".."

FadingWindow {
	id: root
	required property real fraction
	signal input(real fraction)
	anchors.top: true
	color: "transparent"
	width: 240
	height: 64

	HProgressBar {
		anchors { fill: parent; margins: 8 }
		fraction: root.fraction
		onInput: fraction => root.input(fraction)
	}
}
