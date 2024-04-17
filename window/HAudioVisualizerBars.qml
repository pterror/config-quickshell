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
	property var childAlignment: anchors.bottom ? Qt.AlignBottom : Qt.AlignTop
	property int bars: 32
	property int noiseReduction: 70
	property string channels: "mono" // or stereo
	property string monoOption: "average" // or left or right
	property string fillColor: Config.colors.rectangle.bg
	property string strokeColor: "transparent"
	property int strokeWidth: 0
	property int barRadius: Config.layout.rectangle.radius
	height: 320
	
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

	RowLayout2 {
		id: content
		anchors.fill: parent
		property real scale: height / 128.0
		property real childSize: (width + Config.layout.audioVisualizer.gap) / bars - Config.layout.audioVisualizer.gap

		Repeater {
			model: cava.count

			Rectangle {
				required property int modelData
				property int value: 1
				Layout.alignment: root.childAlignment
				color: root.fillColor
				border.color: root.strokeColor
				border.width: root.strokeWidth
				implicitHeight: value * content.scale
				implicitWidth: content.childSize
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