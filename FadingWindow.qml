import Quickshell
import QtQuick

PanelWindow {
	property int persistDuration: 2000
	property int hideHandle: 0
	default property alias content: container.children

	Rectangle {
		id: container
		anchors.fill: parent
		color: "transparent"
		opacity: 0

		Behavior on opacity {
			SmoothedAnimation { velocity: 1 }
		}
	}

	Timer {
		id: hideTimer
		interval: persistDuration
		onTriggered: {
			container.opacity = 0
			finishHideTimer.running = true
		}
	}

	Timer {
		id: finishHideTimer
		interval: 1000
		onTriggered: visible = false
	}

	function show() {
		container.opacity = 1
		finishHideTimer.running = false
		hideTimer.running = true
	}
}
