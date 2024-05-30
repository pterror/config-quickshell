import Quickshell
import QtQuick
import "root:/"

FadingWindow {
	id: root
	required property real fraction
	property alias animationSpeed: progressBar.animationSpeed
	signal input(real fraction)
	anchors.right: true
	color: "transparent"
	width: 64
	height: 240

	VProgressBar {
		id: progressBar
		anchors { fill: parent; margins: 8 }
		fraction: root.fraction
		onInput: fraction => root.input(fraction)
	}
}
