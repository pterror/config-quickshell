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
	Component.onCompleted: {
		if (this.WlrLayershell) this.WlrLayershell.layer = WlrLayer.Bottom
	}
	property bool bottom: anchors.bottom
	property int bars: 32
	property int noiseReduction: 70
	property string channels: "mono" // or stereo
	property string monoOption: "average" // or left or right
	property string fillColor: Config.colors.rectangle.bg
	property string strokeColor: "transparent"
	property int strokeWidth: 0
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

	Shape {
		id: shape
		anchors.fill: parent
		property real scale: height / 128
		property real spacing: width / (bars - 1)

		ShapePath {
			id: path
			fillColor: root.fillColor
			strokeColor: root.strokeColor
			strokeWidth: root.strokeWidth
			startY: root.bottom ? root.height : 0
		}

		Repeater {
			model: cava.count

			Item {
				required property int modelData
				Component.onCompleted: path.pathElements.push(curve)

				PathCurve {
					id: curve
					x: shape.spacing * modelData
					property Connections cavaConnections: Connections {
						target: cava
						function onValue(index, newValue) {
							if (index !== modelData) return
							const height = newValue * shape.scale
							curve.y = root.bottom ? root.height - height : height
						}
					}
				}
			}
		}

		Item {
			PathLine {
				id: finalLine
				Component.onCompleted: path.pathElements.push(finalLine)
				x: root.width
				y: root.bottom ? root.height : 0
			}
		}
	}
}
