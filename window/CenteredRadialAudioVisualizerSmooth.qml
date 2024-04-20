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
	property int outerRadius: 480
	property int innerRadius: 240
	property int centerRadius: (outerRadius + innerRadius) / 2
	property int centerOuterRadius: centerRadius + 8
	property int centerInnerRadius: centerRadius - 8
	property real outerScale: (outerRadius - centerOuterRadius) / 128.0
	property real innerScale: (innerRadius - centerInnerRadius) / 128.0
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
		property real innerY: 0

		Connections {
			target: cava
			function onValue(index, newValue) {
				if (index !== 0) return
				shape.startX = root.width / 2
				shape.startY = root.height / 2 - (root.centerOuterRadius + newValue * root.outerScale)
				shape.innerY = root.height / 2 - (root.centerInnerRadius + newValue * root.innerScale)
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
			id: visualizerCurves
			model: cava.count + 1

			Item {
				required property int modelData

				PathCurve { id: curve }
				PathCurve { id: curve2 }

				Connections {
					target: cava
					property real xMultiplier: Math.cos(((modelData % cava.count) / root.bars - 0.25) * 2 * Math.PI)
					property real yMultiplier: Math.sin(((modelData % cava.count) / root.bars - 0.25) * 2 * Math.PI)
					function onValue(index, newValue) {
						if (index !== modelData % cava.count) return
						const outerHeight = newValue * root.outerScale
						curve.x = root.width / 2 + (root.centerOuterRadius + outerHeight) * xMultiplier
						curve.y = root.height / 2 + (root.centerOuterRadius + outerHeight) * yMultiplier
						const innerHeight = newValue * root.innerScale
						curve2.x = root.width / 2 + (root.centerInnerRadius + innerHeight) * xMultiplier
						curve2.y = root.height / 2 + (root.centerInnerRadius + innerHeight) * yMultiplier
					}
				}
			}
		}

		Item {
			PathLine {
				id: finalLine
				x: shape.startX
				y: shape.innerY
			}
		}

		Item {
			PathLine {
				id: finalLine2
				x: shape.startX
				y: shape.startY
			}
		}
	}

	Component.onCompleted: {
		if (this.WlrLayershell) this.WlrLayershell.layer = WlrLayer.Bottom
		for (let i = 0; i < visualizerCurves.model; i += 1) {
			path.pathElements.push(visualizerCurves.itemAt(i).resources[0])
		}
		path.pathElements.push(finalLine)
		for (let i = 0; i < visualizerCurves.model; i += 1) {
			path.pathElements.push(visualizerCurves.itemAt(i).resources[1])
		}
		path.pathElements.push(finalLine2)
	}
}