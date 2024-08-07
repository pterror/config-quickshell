import Quickshell
import QtQuick
import "root:/"

FadingWindow {
	id: root
	required property real fraction
	property alias animationVelocity: progressBar.animationVelocity
	signal input(real fraction)
	anchors.top: true
	color: "transparent"
	width: 240
	height: 64

	HProgressBar {
		id: progressBar
		anchors { fill: parent; margins: 8 }
		fraction: root.fraction
		onInput: fraction => root.input(fraction)
	}
}
