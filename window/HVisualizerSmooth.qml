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
	property bool bottom: anchors.bottom
	property int bars: 32
	height: 320

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
		opacity: root.opacity
		anchors.fill: parent
		property real spacing: width / (input.count - 1)

		ShapePath {
			id: path
			fillColor: root.fillColor
			strokeColor: root.strokeColor
			strokeWidth: root.strokeWidth
			startY: root.bottom ? root.height : 0
		}

		Repeater {
			id: curves
			model: input.count

			Item {
				required property int modelData

				PathCurve {
					id: curve
					x: shape.spacing * modelData
					property Connections inputConnections: Connections {
						target: input
						function onValue(index, newValue) {
							if (index !== modelData) return
							const height = newValue * shape.height
							curve.y = root.bottom ? root.height - height : height
						}
					}
					Behavior on y {
						SmoothedAnimation { duration: root.animationDuration; velocity: root.animationVelocity }
					}
				}
			}
		}

		Item {
			PathLine { id: finalLine; x: root.width; y: root.bottom ? root.height : 0 }
		}
	}
}
