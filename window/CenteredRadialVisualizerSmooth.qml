import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import Quickshell
import Quickshell.Wayland
import "../component"
import "../io"
import ".."

VisualizerBase {
	id: root
	property int outerRadius: 480
	property int innerRadius: 240
	property int centerRadius: (outerRadius + innerRadius) / 2
	property int centerOuterRadius: centerRadius + 8
	property int centerInnerRadius: centerRadius - 8
	property real outerScale: outerRadius - centerOuterRadius
	property real innerScale: innerRadius - centerInnerRadius
	width: outerRadius * 2
	height: outerRadius * 2
	input: Cava { channels: "stereo" }

	Component.onCompleted: {
		for (let i = 0; i < visualizerCurves.model; i += 1) {
			path.pathElements.push(visualizerCurves.itemAt(i).resources[0])
		}
		path.pathElements.push(finalLine)
		for (let i = 0; i < visualizerCurves.model; i += 1) {
			path.pathElements.push(visualizerCurves.itemAt(i).resources[1])
		}
		path.pathElements.push(finalLine2)
	}

	Shape {
		id: shape
		anchors.fill: parent
		property real spacing: width / (input.count - 1)
		property real startX: 0
		property real startY: 0
		property real innerY: 0

		Connections {
			target: input
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

		Item {
			PathLine { id: finalLine; x: shape.startX; y: shape.innerY }
			PathLine { id: finalLine2; x: shape.startX; y: shape.startY }
		}

		Repeater {
			id: visualizerCurves
			model: input.count + 1

			Item {
				required property int modelData

				PathCurve { id: curve }
				PathCurve { id: curve2 }

				Connections {
					target: input
					property real xMultiplier: Math.cos(((modelData % input.count) / input.count - 0.25) * 2 * Math.PI)
					property real yMultiplier: Math.sin(((modelData % input.count) / input.count - 0.25) * 2 * Math.PI)
					function onValue(index, newValue) {
						if (index !== modelData % input.count) return
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
	}
}
