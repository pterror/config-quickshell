import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import Quickshell
import Quickshell.Wayland
import qs.component
import qs.io
import qs

VisualizerBase {
	id: root
	property int outerRadius: 480
	property int innerRadius: 256
	property int circleRadius: innerRadius - 16
	property real scale: outerRadius - innerRadius
	property real rotationOffset: 0
	property list<var> values: []
	property list<color> colors: []
	property int count: values.length > 0 ? values[0].length : 0
	width: outerRadius * 2
	height: outerRadius * 2

	function cumulative(layer, point) {
		if (layer < 0) return 0
		let sum = 0
		for (let k = 0; k <= layer; k++) sum += values[k][point]
		return sum
	}

	Repeater {
		id: layers
		model: root.values.length

		Shape {
			id: shape
			required property int index
			opacity: root.opacity
			anchors.fill: parent
			property real startX: 0
			property real startY: 0
			property real innerX: 0
			property real innerY: 0

			function redrawPath() {
				path.pathElements = [
					...Array.from({ length: curves.model }, (_, i) => curves.itemAt(i).resources[0]),
					finalLine,
					...Array.from({ length: curves.model }, (_, i) => curves.itemAt(i).resources[1]),
					finalLine2,
				]
			}
			Component.onCompleted: redrawPath()

			Connections {
				target: root
				function onCountChanged() { shape.redrawPath() }
			}

			ShapePath {
				id: path
				fillColor: shape.index < root.colors.length ? root.colors[shape.index] : root.fillColor
				strokeColor: root.strokeColor
				strokeWidth: root.strokeWidth
				startX: shape.startX
				startY: shape.startY
			}

			Item { PathLine { id: finalLine; x: shape.innerX; y: shape.innerY } }
			Item { PathLine { id: finalLine2; x: shape.startX; y: shape.startY } }

			Repeater {
				id: curves
				model: root.count + 1

				Item {
					required property int modelData
					property real outerVal: root.cumulative(shape.index, modelData % root.count)
					property real innerVal: shape.index === 0 ? 0 : root.cumulative(shape.index - 1, modelData % root.count)
					property real xMultiplier: Math.cos(((modelData % root.count) / root.count - 0.25 - rotationOffset / 360) * 2 * Math.PI)
					property real yMultiplier: Math.sin(((modelData % root.count) / root.count - 0.25 - rotationOffset / 360) * 2 * Math.PI)
					Behavior on outerVal {
						SmoothedAnimation { duration: root.animationDuration; velocity: root.animationVelocity }
					}
					Behavior on innerVal {
						SmoothedAnimation { duration: root.animationDuration; velocity: root.animationVelocity }
					}

					PathCurve {
						id: outerCurve
						property real radius: root.innerRadius + outerVal * root.scale
						x: root.width / 2 + radius * xMultiplier
						y: root.height / 2 + radius * yMultiplier
					}

					PathCurve {
						id: innerCurve
						property real radius: shape.index === 0 ? root.circleRadius : root.innerRadius + innerVal * root.scale
						x: root.width / 2 + radius * xMultiplier
						y: root.height / 2 + radius * yMultiplier
					}

					Component.onCompleted: {
						if (modelData !== 0) return
						shape.startX = Qt.binding(() => outerCurve.x)
						shape.startY = Qt.binding(() => outerCurve.y)
						shape.innerX = Qt.binding(() => innerCurve.x)
						shape.innerY = Qt.binding(() => innerCurve.y)
					}
				}
			}
		}
	}
}
