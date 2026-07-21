import Quickshell
import QtQuick
import QtQuick.Effects
import qs

// Volume/brightness OSD: frosted-glass pill with a soft drop shadow (the 8px
// margin below gives the shadow room to render without being clipped by the
// window's own surface bounds).
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
