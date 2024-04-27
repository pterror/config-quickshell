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
	property bool bottom: anchors.bottom
	property int bars: 32
	property int noiseReduction: 70
	property string channels: "stereo" // or stereo
	property string monoOption: "average" // or left or right
	property string fillColor: Config.colors.rectangle.bg
	property string strokeColor: "transparent"
	property int strokeWidth: 0
	property int outerRadius: 464
	property int innerRadius: 240
	property int circleRadius: outerRadius + 16
	property real scale: (outerRadius - innerRadius) / 128
	width: outerRadius * 2
	height: outerRadius * 2

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
		property real spacing: width / (bars - 1)
		property real startX: 0
		property real startY: 0
		property Connections cavaConnections: Connections {
			target: cava
			function onValue(index, newValue) {
				if (index !== 0) return
				const height = newValue * root.scale
				shape.startX = root.width / 2
				shape.startY = root.height / 2 - (root.outerRadius - height)
			}
		}

		ShapePath {
			id: path
			fillColor: root.fillColor
			strokeColor: root.strokeColor
			strokeWidth: root.strokeWidth
			startX: shape.startX
			startY: shape.startY
		}

		Repeater {
			id: visualizerCurve
			model: cava.count + 1

			Item {
				required property int modelData

				PathCurve {
					id: curve
					property Connections cavaConnections: Connections {
						target: cava
						property real xMultiplier: Math.cos(((modelData % cava.count) / root.bars - 0.25) * 2 * Math.PI)
						property real yMultiplier: Math.sin(((modelData % cava.count) / root.bars - 0.25) * 2 * Math.PI)
						function onValue(index, newValue) {
							if (index !== modelData % cava.count) return
							const height = newValue * root.scale
							curve.x = root.width / 2 + (root.outerRadius - height) * xMultiplier
							curve.y = root.height / 2 + (root.outerRadius - height) * yMultiplier
						}
					}
				}
			}
		}

		PathLine { id: finalLine; x: root.width / 2; y: root.height / 2 - root.circleRadius }

		Repeater {
			id: outerCircle
			model: 13

			Item {
				required property int modelData

				PathCurve {
					x: root.width / 2 + root.circleRadius * Math.cos((modelData / (outerCircle.model - 1) - 0.25) * 2 * Math.PI)
					y: root.height / 2 + root.circleRadius * Math.sin((modelData / (outerCircle.model - 1) - 0.25) * 2 * Math.PI)
				}
			}
		}

		PathLine { id: finalLine2; x: shape.startX; y: shape.startY }
	}

	Component.onCompleted: {
		if (this.WlrLayershell) this.WlrLayershell.layer = WlrLayer.Bottom
		for (let i = 0; i < visualizerCurve.model; i += 1) {
			path.pathElements.push(visualizerCurve.itemAt(i).resources[0])
		}
		path.pathElements.push(finalLine)
		for (let i = 0; i < outerCircle.model; i += 1) {
			path.pathElements.push(outerCircle.itemAt(i).resources[0])
		}
		path.pathElements.push(finalLine2)
	}
}
