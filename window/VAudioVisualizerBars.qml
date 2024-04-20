import QtQuick
import QtQuick.Layouts
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
	Component.onCompleted: {
		if (this.WlrLayershell) this.WlrLayershell.layer = WlrLayer.Bottom
	}
	property var childAlignment: anchors.right ? Qt.AlignRight | Qt.AlignVCenter : Qt.AlignLeft | Qt.AlignVCenter
	property int bars: 32
	property int noiseReduction: 70
	property string channels: "mono" // or stereo
	property string monoOption: "average" // or left or right
	property string fillColor: Config.colors.rectangle.bg
	property string strokeColor: "transparent"
	property int strokeWidth: 0
	property int barRadius: Config.layout.rectangle.radius
	width: 480
	
	Cava {
		id: cava
		config: ({
			general: { bars: bars },
			smoothing: { noise_reduction: noiseReduction },
			output: {
				method: "raw",
				bit_format: 8,
				channels: channels,
				mono_option: monoOption,
			}
		})
	}

	ColumnLayout2 {
		id: content
		anchors.fill: parent
		property real scale: height / 128.0
		property real childSize: (height + Config.layout.audioVisualizer.gap) / bars - Config.layout.audioVisualizer.gap

		Repeater {
			model: cava.count

			Rectangle {
				required property int modelData
				property int value: 0
				Layout.alignment: root.childAlignment
				color: root.fillColor
				border.color: root.strokeColor
				border.width: root.strokeWidth
				implicitHeight: content.childSize
				implicitWidth: value * content.scale
				radius: root.barRadius

				Connections {
					target: cava
					function onValue(index, newValue) {
						if (index !== modelData) return
						value = newValue
					}
				}
			}
		}
	}
}