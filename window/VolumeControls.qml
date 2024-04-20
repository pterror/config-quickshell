import Quickshell
import "../widget"
import ".."

PopupWindow {
	id: root
	property string widgetColor: Config.colors.panel.bg
	property int radius: Config.layout.panel.radius
	property int margins: Config.layout.panel.margins
	property int spacing: Config.layout.mediaPlayer.controlsGap

	color: "transparent"
	width: content.implicitWidth
	height: content.implicitHeight

	VolumeControlsWidget {
		id: content
		color: root.widgetColor
		radius: root.radius
		margins: root.margins
		spacing: root.spacing
	}
}
