import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "../component"
import "../input"
import ".."

PanelWindow {
	id: root
	color: "transparent"
	WlrLayershell.namespace: "shell:audio_visualizer"
	property var columnAlignment: anchors.bottom ? Qt.AlignBottom : Qt.AlignTop
	property int bars: 32
	property int noiseReduction: 60
	property string channels: "mono" // or stereo
	property string monoOption: "average" // or left or right
	property string innerColor: "white"
	width: 1920
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
		width: root.width
		height: root.height
		property real scale: height / 128.0
		property real columnWidth: (width + Config.layout.audioVisualizer.gap) / bars - Config.layout.audioVisualizer.gap

		Repeater {
			model: cava.count

			Rectangle {
				required property int modelData
				property int value: 1
				Layout.alignment: root.columnAlignment
				color: root.innerColor
				implicitHeight: value * content.scale
				implicitWidth: content.columnWidth

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