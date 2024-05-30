import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import Quickshell
import Quickshell.Wayland
import "root:/component"
import "root:/io"
import "root:/"

VisualizerBase {
	id: root
	property int outerRadius: 448
	property int innerRadius: 240
	property int circleRadius: outerRadius + 32
	property real scale: outerRadius - innerRadius
	property real rotationOffset: 0
	width: outerRadius * 2
	height: outerRadius * 2
	inputDelegate: Cava { channels: "stereo" }

	function redrawPath() {
		path.pathElements = [
			...Array.from({ length: visualizerCurve.model }, (_, i) => visualizerCurve.itemAt(i).resources[0]),
			finalLine,
			...Array.from({ length: circle.model }, (_, i) => circle.itemAt(i).resources[0]),
			finalLine2,
		]
	}

	Connections { target: input; function onCountChanged() { console.log(':0', input.count); redrawPath() } }

	Shape {
		id: shape
		opacity: root.opacity
		anchors.fill: parent
		property real spacing: width / (input.count - 1)
		property real startX: 0
		property real startY: 0

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
					property real height: input.values[modelData % input.count] * root.scale
					property real xMultiplier: Math.cos(((modelData % input.count) / input.count - 0.25 - rotationOffset / 360) * 2 * Math.PI)
					property real yMultiplier: Math.sin(((modelData % input.count) / input.count - 0.25 - rotationOffset / 360) * 2 * Math.PI)
					x: root.width / 2 + (root.outerRadius - height) * xMultiplier
					y: root.height / 2 + (root.outerRadius - height) * yMultiplier
					property var what: console.log('height', height, modelData, modelData % input.count)
					Component.onCompleted: {
						if (modelData === 0) { shape.startX = Qt.binding(() => x); shape.startY = Qt.binding(() => y) }
					}
					Behavior on height {
						SmoothedAnimation { duration: root.animationDuration; velocity: root.animationVelocity }
					}
				}
			}
		}

		Repeater {
			id: circle
			model: 13

			Item {
				required property int modelData

				PathCurve {
					x: root.width / 2 + root.circleRadius * Math.cos((modelData / (circle.model - 1) - 0.25) * 2 * Math.PI)
					y: root.height / 2 + root.circleRadius * Math.sin((modelData / (circle.model - 1) - 0.25) * 2 * Math.PI)
				}
			}
		}
	}
}
