import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import "../widget"
import ".."

PanelWindow {
	color: "transparent"
	width: content.implicitWidth
	height: content.implicitHeight
	Component.onCompleted: {
		if (this.WlrLayershell) this.WlrLayershell.layer = WlrLayer.Bottom
	}

	AnalogClockWidget { id: content }
}
