import QtQuick
import QtQuick.Effects
import Quickshell as Q
import Quickshell.Hyprland
import qs

Q.PopupWindow {
	default property alias content: container.children
	color: "transparent"
	implicitWidth: container.children[0].implicitWidth || 1
	implicitHeight: container.children[0].implicitHeight || 1

	id: root
	property list<var> extraGrabWindows: []
	// Fired when the popup stops being visible for any reason, including
	// HyprlandFocusGrab dismissing it via an outside click. Callers that
	// gate a LazyLoader (or other toggle state) on this popup's presence
	// must listen for this to stay in sync — otherwise the toggle believes
	// the popup is still open after an outside-click dismiss, and the next
	// trigger click "closes" an already-closed popup instead of reopening
	// it.
	signal dismissed()
	onVisibleChanged: {
		grab.active = visible
		if (!visible) dismissed()
	}

	HyprlandFocusGrab {
		id: grab; windows: [root].concat(extraGrabWindows); active: true
		onActiveChanged: root.visible = active
	}

	// Frosted-glass card: translucent tint + hairline border + soft drop shadow.
	// No backdrop blur.
	Rectangle {
		id: container
		color: Config._.style.window.bg
		radius: Config._.style.window.radius
		border.color: Config._.style.window.outline
		border.width: Config._.style.window.border
		anchors.fill: parent
		// Clip content to the rounded rect — otherwise any child that fills the
		// popup with its own square-cornered background (e.g. VisualizerShowcaseContent)
		// paints straight over the rounding and hides the translucent glass tint.
		clip: true

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
