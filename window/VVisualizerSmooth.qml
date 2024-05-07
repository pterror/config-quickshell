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
			model: input.count

			Item {
				required property int modelData
				Component.onCompleted: path.pathElements.push(curve)

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
				}
			}
		}

		Item {
			PathLine {
				id: finalLine
				Component.onCompleted: path.pathElements.push(finalLine)
				x: root.right ? root.width : 0
				y: root.height
			}
		}
	}
}