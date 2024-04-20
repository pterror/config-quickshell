import Quickshell
import "../widget"
import ".."

PopupWindow {
	color: "transparent"
	width: content.implicitWidth
	height: content.implicitHeight

	VolumeControlsWidget { id: content; color: Config.colors.panel.bg }
}
