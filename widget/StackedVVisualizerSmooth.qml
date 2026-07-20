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
	property bool onRight: anchors.right === parent.right
	property list<var> values: []
	property list<color> colors: []
	property int count: values.length > 0 ? values[0].length : 0
	width: 480

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
			property real spacing: root.count > 1 ? height / (root.count - 1) : 0
			property real startX: root.onRight ? root.width : 0
			property real startY: 0

			function redrawPath() {
				path.pathElements = [
					...Array.from({ length: topCurves.model }, (_, i) => topCurves.itemAt(i).resources[0]),
					finalLine,
					...Array.from({ length: bottomCurves.model }, (_, i) => bottomCurves.itemAt(bottomCurves.model - 1 - i).resources[0]),
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

			Repeater {
				id: topCurves
				model: root.count

				Item {
					required property int modelData

					PathCurve {
						x: {
							const width = root.cumulative(shape.index, modelData) * shape.width
							return root.onRight ? root.width - width : width
						}
						y: shape.spacing * modelData
						Behavior on x {
							SmoothedAnimation { duration: root.animationDuration; velocity: root.animationVelocity }
						}
					}
				}
			}

			Repeater {
				id: bottomCurves
				model: root.count

				Item {
					required property int modelData

					PathCurve {
						id: bcurve
						x: {
							const width = root.cumulative(shape.index - 1, modelData) * shape.width
							return root.onRight ? root.width - width : width
						}
						y: shape.spacing * modelData
						Behavior on x {
							SmoothedAnimation { duration: root.animationDuration; velocity: root.animationVelocity }
						}
					}

					Component.onCompleted: {
						if (modelData === 0) shape.startX = Qt.binding(() => bcurve.x)
						if (modelData === root.count - 1) finalLine.x = Qt.binding(() => bcurve.x)
					}
				}
			}

			Item { PathLine { id: finalLine; x: root.onRight ? root.width : 0; y: root.height } }
		}
	}
}
