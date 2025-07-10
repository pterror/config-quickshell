import Quickshell
import QtQuick
import qs

FadingWindow {
	id: root
	required property real fraction
	property alias animationVelocity: progressBar.animationVelocity
	signal input(real fraction)
	color: "transparent"
	implicitWidth: 240
	implicitHeight: 64

	HProgressBar {
		id: progressBar
		anchors { fill: parent; margins: 8 }
		fraction: root.fraction
		onInput: fraction => root.input(fraction)
	}
}
