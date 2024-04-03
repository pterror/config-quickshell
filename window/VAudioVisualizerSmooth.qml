import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import Quickshell
import Quickshell.Wayland
import "../component"
import "../input"
import ".."

PanelWindow {
	id: root
	color: "transparent"
	WlrLayershell.namespace: "shell:audio_visualizer"
	exclusiveZone: 0
	Component.onCompleted: {
		if (this.WlrLayershell) this.WlrLayershell.layer = WlrLayer.Bottom
	}
	property bool right: anchors.right
	property int bars: 32
	property int noiseReduction: 70
	property string channels: "mono" // or stereo
	property string monoOption: "average" // or left or right
	property string fillColor: "#30ffeef8"
	property string strokeColor: "transparent"
	property int strokeWidth: 0
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

	Shape {
		id: shape
		anchors.fill: parent
		property real scale: width / 128.0
		property real spacing: height / (bars - 1)

		ShapePath {
			id: path
			fillColor: root.fillColor
			strokeColor: root.strokeColor
			strokeWidth: root.strokeWidth
			startX: root.right ? root.width : 0
		}

		Repeater {
			model: cava.count

			Item {
				required property int modelData
				Component.onCompleted: path.pathElements.push(curve)

				PathCurve {
					id: curve
					property int value: 1
					y: shape.spacing * modelData
					property Connections cavaConnections: Connections {
						target: cava
						function onValue(index, newValue) {
							if (index !== modelData) return
							const width = newValue * shape.scale
							curve.x = root.right ? root.width - width : width
						}
					}
				}
			}
		}

		Item {
			PathLine {
				id: finalLine
				Component.onCompleted: path.pathElements.push(finalLine)
				x: root.right ? root.width : 0
				y: root.height
			}
		}
	}
}