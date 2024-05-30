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
	property bool onRight: anchors.right === parent.right
	width: 480
	Component.onCompleted: redrawPath()

	function redrawPath() {
		path.pathElements = [
			...Array.from({ length: curves.model }, (_, i) => curves.itemAt(i).resources[0]),
			finalLine,
		]
	}

	Connections {
		target: input
		function onCountChanged() { redrawPath() }
	}

	Shape {
		id: shape
		opacity: root.opacity
		anchors.fill: parent
		property real spacing: height / (input.count - 1)

		ShapePath {
			id: path
			fillColor: root.fillColor
			strokeColor: root.strokeColor
			strokeWidth: root.strokeWidth
			startX: root.onRight ? root.width : 0
		}

		Repeater {
			id: curves
			model: input.count

			Item {
				required property int modelData

				PathCurve {
					x: {
						const width = input.values[modelData] * shape.width
						return root.onRight ? root.width - width : width
					}
					y: shape.spacing * modelData
					Behavior on x {
						SmoothedAnimation { duration: root.animationDuration; velocity: root.animationVelocity }
					}
				}
			}
		}

		Item {
			PathLine { id: finalLine; x: root.onRight ? root.width : 0; y: root.height }
		}
	}
}
