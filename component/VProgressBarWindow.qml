import Quickshell
import QtQuick
import "root:/"

FadingWindow {
	id: root
	required property real fraction
	property alias animationVelocity: progressBar.animationVelocity
	signal input(real fraction)
	color: "transparent"
	implicitWidth: 64
	implicitHeight: 240

	VProgressBar {
		id: progressBar
		anchors { fill: parent; margins: 8 }
		fraction: root.fraction
		onInput: fraction => root.input(fraction)
	}
}
