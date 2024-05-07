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
	property int innerRadius: 256
	property int circleRadius: innerRadius - 16
	property real scale: outerRadius - innerRadius
	width: outerRadius * 2
	height: outerRadius * 2
	input: Cava { channels: "stereo" }

	Shape {
		id: shape
		anchors.fill: parent
		property real spacing: width / (input.count - 1)
		property real startX: 0
		property real startY: 0
		property Connections inputConnections: Connections {
			target: input
			function onValue(index, newValue) {
				if (index !== 0) return
				const height = newValue * root.scale
				shape.startX = root.width / 2
				shape.startY = root.height / 2 - (root.innerRadius + height)
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
			model: input.count + 1

			Item {
				required property int modelData

				PathCurve {
					id: curve
					property Connections inputConnections: Connections {
						target: input
						property real xMultiplier: Math.cos(((modelData % input.count) / input.count - 0.25) * 2 * Math.PI)
						property real yMultiplier: Math.sin(((modelData % input.count) / input.count - 0.25) * 2 * Math.PI)
						function onValue(index, newValue) {
							if (index !== modelData % input.count) return
							const height = newValue * root.scale
							curve.x = root.width / 2 + (root.innerRadius + height) * xMultiplier
							curve.y = root.height / 2 + (root.innerRadius + height) * yMultiplier
						}
					}
				}
			}
		}

		Item {
			PathLine {
				id: finalLine
				x: root.width / 2
				y: root.height / 2 - root.circleRadius
			}
		}

		Repeater {
			id: innerCircle
			model: 13

			Item {
				required property int modelData

				PathCurve {
					x: root.width / 2 + root.circleRadius * Math.cos((modelData / (innerCircle.model - 1) - 0.25) * 2 * Math.PI)
					y: root.height / 2 + root.circleRadius * Math.sin((modelData / (innerCircle.model - 1) - 0.25) * 2 * Math.PI)
				}
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
		for (let i = 0; i < visualizerCurve.model; i += 1) {
			path.pathElements.push(visualizerCurve.itemAt(i).resources[0])
		}
		path.pathElements.push(finalLine)
		for (let i = 0; i < innerCircle.model; i += 1) {
			path.pathElements.push(innerCircle.itemAt(i).resources[0])
		}
		path.pathElements.push(finalLine2)
	}
}
