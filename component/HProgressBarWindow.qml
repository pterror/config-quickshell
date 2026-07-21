import Quickshell
import QtQuick
import QtQuick.Effects
import qs

// See VProgressBarWindow.qml — same frosted-glass OSD pill treatment, horizontal.
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

		layer.enabled: true
		layer.effect: MultiEffect {
			shadowEnabled: true
			shadowColor: Config._.style.glass.shadowColor
			shadowBlur: Config._.style.glass.shadowBlur
			shadowVerticalOffset: Config._.style.glass.shadowVerticalOffset
			shadowHorizontalOffset: Config._.style.glass.shadowHorizontalOffset
			blurEnabled: false
		}
	}
}
