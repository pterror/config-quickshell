import Quickshell
import Quickshell.Hyprland

PopupWindow {
	id: root
	onVisibleChanged: if (visible) grab.active = true

	HyprlandFocusGrab {
		id: grab; windows: [root]
		onActiveChanged: if (!active) root.visible = false
	}
}
