import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import Quickshell
import Quickshell.Wayland
import "../component"
import "../io"
import ".."

PanelWindow {
	id: root
	color: "transparent"
	WlrLayershell.namespace: "shell:audio_visualizer"
	exclusiveZone: 0
	Component.onCompleted: if (this.WlrLayershell) this.WlrLayershell.layer = WlrLayer.Bottom
	property bool right: anchors.right
	property string fillColor: Config.colors.visualizer.barsBg
	property string strokeColor: "transparent"
	property int strokeWidth: 0
	property real animationDuration: 0
	property real animationVelocity: 1
	property real opacity: 1
	property var input: Cava {}
}
