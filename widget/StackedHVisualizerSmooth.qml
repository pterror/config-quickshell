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
	property bool onBottom: anchors.bottom === parent.bottom
	property list<var> values: []
	property list<color> colors: []
	property int count: values.length > 0 ? values[0].length : 0
	height: 320

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
			property real spacing: root.count > 1 ? width / (root.count - 1) : 0
			property real startX: 0
			property real startY: root.onBottom ? root.height : 0

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
						x: shape.spacing * modelData
						y: {
							const height = root.cumulative(shape.index, modelData) * shape.height
							return root.onBottom ? root.height - height : height
						}
						Behavior on y {
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
						x: shape.spacing * modelData
						y: {
							const height = root.cumulative(shape.index - 1, modelData) * shape.height
							return root.onBottom ? root.height - height : height
						}
						Behavior on y {
							SmoothedAnimation { duration: root.animationDuration; velocity: root.animationVelocity }
						}
					}

					Component.onCompleted: {
						if (modelData === 0) shape.startY = Qt.binding(() => bcurve.y)
						if (modelData === root.count - 1) finalLine.y = Qt.binding(() => bcurve.y)
					}
				}
			}

			Item { PathLine { id: finalLine; x: root.width; y: root.onBottom ? root.height : 0 } }
		}
	}
}
