import Quickshell
import Quickshell.Hyprland

PopupWindow {
	id: root
	property list<var> extraGrabWindows: []
	onVisibleChanged: grab.active = visible

	HyprlandFocusGrab {
		id: grab; windows: [root].concat(extraGrabWindows)
		onActiveChanged: root.visible = active
	}
}
