import QtQuick
import Quickshell
import Quickshell.Wayland

PanelWindow {
	property int persistDuration: 1000
	color: "transparent"
	default property alias content: container.children

	Rectangle {
		id: container
		anchors.fill: parent
		color: "transparent"
		opacity: 0

		SmoothedAnimation {
			id: hide
			target: container
			property: "opacity"
			from: 1; to: 0
			velocity: 2.5
			onFinished: visible = false
		}
	}

	Timer {
		id: hideTimer
		interval: persistDuration
		onTriggered: hide.restart()
	}

	function show() {
		visible = true
		container.opacity = 1
		hideTimer.restart()
		hide.stop()
	}
}
