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
	property bool right: anchors.right
	width: 480

	Connections {
		target: input
		function onCountChanged() {
			path.pathElements = [
				...Array.from({ length: curves.model }, (_, i) => curves.itemAt(i).resources[0]),
				finalLine,
			]
		}
	}

	Shape {
		id: shape
		anchors.fill: parent
		property real spacing: height / (input.count - 1)

		ShapePath {
			id: path
			fillColor: root.fillColor
			strokeColor: root.strokeColor
			strokeWidth: root.strokeWidth
			startX: root.right ? root.width : 0
		}

		Repeater {
			id: curves
			model: input.count

			Item {
				required property int modelData

				PathCurve {
					id: curve
					y: shape.spacing * modelData
					property Connections inputConnections: Connections {
						target: input
						function onValue(index, newValue) {
							if (index !== modelData) return
							const width = newValue * shape.width
							curve.x = root.right ? root.width - width : width
						}
					}
					Behavior on x {
						SmoothedAnimation { duration: root.animationDuration; velocity: root.animationVelocity }
					}
				}
			}
		}

		Item {
			PathLine { id: finalLine; x: root.right ? root.width : 0; y: root.height }
		}
	}
}
