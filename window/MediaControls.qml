import Quickshell
import "../widget"
import ".."

PopupWindow {
	property alias color: content.color
	property alias radius: content.radius
	property alias margins: content.margins
	property alias spacing: content.spacing

	color: "transparent"
	width: content.implicitWidth
	height: content.implicitHeight
	MediaControlsWidget { id: content; color: Config.colors.panel.bg }
}
