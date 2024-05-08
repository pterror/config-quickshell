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
	property int outerRadius: 448
	property int innerRadius: 240
	property int circleRadius: outerRadius + 32
	property real scale: outerRadius - innerRadius
	width: outerRadius * 2
	height: outerRadius * 2
	input: Cava { channels: "stereo" }

	Connections {
		target: input
		function onCountChanged() {
			path.pathElements = [
				...Array.from({ length: visualizerCurve.model }, (_, i) => visualizerCurve.itemAt(i).resources[0]),
				finalLine,
				...Array.from({ length: outerCircle.model }, (_, i) => outerCircle.itemAt(i).resources[0]),
				finalLine2,
			]
		}
	}

	Shape {
		id: shape
		anchors.fill: parent
		property real spacing: width / (input.count - 1)
		property real startHeight: 0
		property real startX: root.width / 2
		property real startY: root.height / 2 - (root.outerRadius - startHeight)
		Behavior on startHeight {
			SmoothedAnimation { duration: root.animationDuration; velocity: root.animationVelocity }
		}

		ShapePath {
			id: path
			fillColor: root.fillColor
			strokeColor: root.strokeColor
			strokeWidth: root.strokeWidth
			startX: shape.startX
			startY: shape.startY
		}

		PathLine { id: finalLine; x: root.width / 2; y: root.height / 2 - root.circleRadius }
		PathLine { id: finalLine2; x: shape.startX; y: shape.startY }

		Repeater {
			id: visualizerCurve
			model: input.count + 1

			Item {
				required property int modelData

				PathCurve {
					id: curve
					property real height: 0
					property real xMultiplier: Math.cos(((modelData % input.count) / input.count - 0.25) * 2 * Math.PI)
					property real yMultiplier: Math.sin(((modelData % input.count) / input.count - 0.25) * 2 * Math.PI)
					x: root.width / 2 + (root.outerRadius - height) * xMultiplier
					y: root.height / 2 + (root.outerRadius - height) * yMultiplier
					property Connections inputConnections: Connections {
						target: input
						function onValue(index, newValue) {
							if (index !== modelData % input.count) return
							const height = newValue * root.scale
							curve.height = height
							if (index === 0) shape.startHeight = height
						}
					}
					Behavior on height {
						SmoothedAnimation { duration: root.animationDuration; velocity: root.animationVelocity }
					}
				}
			}
		}

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
	}
}
