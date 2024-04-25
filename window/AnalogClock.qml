import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import "../widget"
import ".."

PanelWindow {
	property alias radius: content.radius
	property alias tickHeight: content.tickHeight
	property alias tickWidth: content.tickWidth
	property alias tickRadius: content.tickRadius
	property alias secondHandVisible: content.secondHandVisible
	property alias minuteHandVisible: content.minuteHandVisible
	property alias hourHandVisible: content.hourHandVisible

	color: "transparent"
	width: content.implicitWidth
	height: content.implicitHeight
	WlrLayershell.namespace: "shell:analog_clock"
	Component.onCompleted: {
		if (this.WlrLayershell) this.WlrLayershell.layer = WlrLayer.Bottom
	}

	AnalogClockWidget { id: content }
}
