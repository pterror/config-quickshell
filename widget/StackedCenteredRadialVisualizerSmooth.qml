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
	property int innerRadius: 240
	property int centerRadius: (outerRadius + innerRadius) / 2
	property int centerOuterRadius: centerRadius + 8
	property int centerInnerRadius: centerRadius - 8
	property real outerScale: outerRadius - centerOuterRadius
	property real innerScale: innerRadius - centerInnerRadius
	property real rotationOffset: 0
	property list<var> outerValues: []
	property list<color> outerColors: []
	property list<var> innerValues: []
	property list<color> innerColors: []
	property int outerCount: outerValues.length > 0 ? outerValues[0].length : 0
	property int innerCount: innerValues.length > 0 ? innerValues[0].length : 0
	width: outerRadius * 2
	height: outerRadius * 2

	function cumulativeOf(list, layer, point) {
		if (layer < 0) return 0
		let sum = 0
		for (let k = 0; k <= layer; k++) sum += list[k][point]
		return sum
	}

	// Ring growing outward from centerOuterRadius toward outerRadius, layer by layer.
	Repeater {
		id: outerLayers
		model: root.outerValues.length

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
				function onOuterCountChanged() { shape.redrawPath() }
			}

			ShapePath {
				id: path
				fillColor: shape.index < root.outerColors.length ? root.outerColors[shape.index] : root.fillColor
				strokeColor: root.strokeColor
				strokeWidth: root.strokeWidth
				startX: shape.startX
				startY: shape.startY
			}

			Item { PathLine { id: finalLine; x: shape.innerX; y: shape.innerY } }
			Item { PathLine { id: finalLine2; x: shape.startX; y: shape.startY } }

			Repeater {
				id: curves
				model: root.outerCount + 1

				Item {
					required property int modelData
					property real outerVal: root.cumulativeOf(root.outerValues, shape.index, modelData % root.outerCount)
					property real innerVal: root.cumulativeOf(root.outerValues, shape.index - 1, modelData % root.outerCount)
					property real xMultiplier: Math.cos(((modelData % root.outerCount) / root.outerCount - 0.25 - rotationOffset / 360) * 2 * Math.PI)
					property real yMultiplier: Math.sin(((modelData % root.outerCount) / root.outerCount - 0.25 - rotationOffset / 360) * 2 * Math.PI)
					Behavior on outerVal {
						SmoothedAnimation { duration: root.animationDuration; velocity: root.animationVelocity }
					}
					Behavior on innerVal {
						SmoothedAnimation { duration: root.animationDuration; velocity: root.animationVelocity }
					}

					PathCurve {
						id: outerCurve
						property real radius: root.centerOuterRadius + outerVal * root.outerScale
						x: root.width / 2 + radius * xMultiplier
						y: root.height / 2 + radius * yMultiplier
					}

					PathCurve {
						id: innerCurve
						property real radius: root.centerOuterRadius + innerVal * root.outerScale
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

	// Ring growing inward from centerInnerRadius toward innerRadius, layer by layer.
	Repeater {
		id: innerLayers
		model: root.innerValues.length

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
				function onInnerCountChanged() { shape.redrawPath() }
			}

			ShapePath {
				id: path
				fillColor: shape.index < root.innerColors.length ? root.innerColors[shape.index] : root.fillColor
				strokeColor: root.strokeColor
				strokeWidth: root.strokeWidth
				startX: shape.startX
				startY: shape.startY
			}

			Item { PathLine { id: finalLine; x: shape.innerX; y: shape.innerY } }
			Item { PathLine { id: finalLine2; x: shape.startX; y: shape.startY } }

			Repeater {
				id: curves
				model: root.innerCount + 1

				Item {
					required property int modelData
					property real outerVal: root.cumulativeOf(root.innerValues, shape.index - 1, modelData % root.innerCount)
					property real innerVal: root.cumulativeOf(root.innerValues, shape.index, modelData % root.innerCount)
					property real xMultiplier: Math.cos(((modelData % root.innerCount) / root.innerCount - 0.25 - rotationOffset / 360) * 2 * Math.PI)
					property real yMultiplier: Math.sin(((modelData % root.innerCount) / root.innerCount - 0.25 - rotationOffset / 360) * 2 * Math.PI)
					Behavior on outerVal {
						SmoothedAnimation { duration: root.animationDuration; velocity: root.animationVelocity }
					}
					Behavior on innerVal {
						SmoothedAnimation { duration: root.animationDuration; velocity: root.animationVelocity }
					}

					PathCurve {
						id: outerCurve
						property real radius: root.centerInnerRadius + outerVal * root.innerScale
						x: root.width / 2 + radius * xMultiplier
						y: root.height / 2 + radius * yMultiplier
					}

					PathCurve {
						id: innerCurve
						property real radius: root.centerInnerRadius + innerVal * root.innerScale
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
