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
	property real rotationOffset: 0
	width: outerRadius * 2
	height: outerRadius * 2
	inputDelegate: Cava { channels: "stereo" }

	function redrawPath() {
			path.pathElements = [
				...Array.from({ length: visualizerCurves.model }, (_, i) => visualizerCurves.itemAt(i).resources[0]),
				finalLine,
				...Array.from({ length: visualizerCurves.model }, (_, i) => visualizerCurves.itemAt(i).resources[1]),
				finalLine2,
			]
	}

	Connections { target: input; function onCountChanged() { redrawPath() } }

	Shape {
		id: shape
		opacity: root.opacity
		anchors.fill: parent
		property real spacing: width / (input.count - 1)
		property real startValue: 0
		property real startX: root.width / 2
		property real startY: root.height / 2 - (root.centerOuterRadius + startValue * root.outerScale)
		property real innerX: root.width / 2
		property real innerY: root.height / 2 - (root.centerInnerRadius + startValue * root.innerScale)
		Behavior on startValue {
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

		Item {
			PathLine { id: finalLine; x: shape.innerX; y: shape.innerY }
			PathLine { id: finalLine2; x: shape.startX; y: shape.startY }
		}

		Repeater {
			id: visualizerCurves
			model: input.count + 1

			Item {
				required property int modelData
				property real value: input.values[modelData % input.count]
				property real xMultiplier: Math.cos(((modelData % input.count) / input.count - 0.25 - rotationOffset / 360) * 2 * Math.PI)
				property real yMultiplier: Math.sin(((modelData % input.count) / input.count - 0.25 - rotationOffset / 360) * 2 * Math.PI)
				Behavior on value {
					SmoothedAnimation { duration: root.animationDuration; velocity: root.animationVelocity }
				}

				PathCurve {
					id: curve
					property var height: value * root.outerScale
					x: root.width / 2 + (root.centerOuterRadius + height) * xMultiplier
					y: root.height / 2 + (root.centerOuterRadius + height) * yMultiplier
				}

				PathCurve {
					id: innerCurve
					property var height: value * root.innerScale
					x: root.width / 2 + (root.centerInnerRadius + height) * xMultiplier
					y: root.height / 2 + (root.centerInnerRadius + height) * yMultiplier
				}

				Component.onCompleted: {
					if (modelData !== 0) return
					shape.startX = Qt.binding(() => curve.x)
					shape.startY = Qt.binding(() => curve.y)
					shape.innerX = Qt.binding(() => innerCurve.x)
					shape.innerY = Qt.binding(() => innerCurve.y)
				}
			}
		}
	}
}
