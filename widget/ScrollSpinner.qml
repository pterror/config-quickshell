import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import qs.widget
import qs

Rectangle {
	color: "transparent"
	width: content.implicitWidth
	height: content.implicitHeight
	Component.onCompleted: if (this.WlrLayershell) this.WlrLayershell.layer = WlrLayer.Bottom

	Spinner { id: content }

	WheelHandler {
		acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
		onWheel: event => {
			content.spin((event.angleDelta.x + event.angleDelta.y) / 4)
		}
	}
}
