import Quickshell
import Quickshell.Hyprland

PopupWindow {
	color: "transparent"
	width: contentItem.children[0].implicitWidth || 1
	height: contentItem.children[0].implicitHeight || 1

	id: root
	property list<var> extraGrabWindows: []
	onVisibleChanged: grab.active = visible

	HyprlandFocusGrab {
		id: grab; windows: [root].concat(extraGrabWindows); active: true
		onActiveChanged: root.visible = active
	}
}
