import QtQuick
import qs

// Generalized version of widget/InwardsRadialVisualizerBars.qml that stacks N data
// layers per bar (e.g. CPU usage + iowait) instead of rendering a single value per bar.
//
// `values` is structure-of-arrays: values[layer][barIndex]. `colors` is indexed by
// layer, so colors[layer] paints values[layer]. Layer 0 renders closest to the rim,
// each subsequent layer stacks further inward.
Rectangle {
	id: root
	color: "transparent"
	required property list<var> values
	required property list<color> colors
	property int count: values.length > 0 ? values[0].length : 0
	property int outerRadius: 220
	property int innerRadius: 120
	property int barRadius: Config._.style.rectangle.radius
	property real scale: outerRadius - innerRadius
	property real barWidth: (innerRadius * 2 * Math.PI) / Math.max(count, 1) - 4
	property real animationDuration: 1000
	property real animationVelocity: 0.0001
	property real rotationOffset: 0
	property bool modulateOpacity: false
	property real minOpacity: 0.4
	property real maxOpacity: 1.0
	width: outerRadius * 2
	height: outerRadius * 2

	Repeater {
		model: root.count

		Item {
			id: barItem
			required property int modelData
			property real angle: (modelData / root.count - 0.25 - root.rotationOffset / 360) * 2 * Math.PI
			x: root.width / 2 + root.outerRadius * Math.cos(angle) - root.barWidth / 2
			y: root.height / 2 + root.outerRadius * Math.sin(angle)
			width: root.barWidth
			height: root.scale
			transform: Rotation {
				origin.x: root.barWidth / 2; origin.y: 0; axis { x: 0; y: 0; z: 1 }
				angle: 360 * barItem.modelData / root.count - root.rotationOffset
			}

			Repeater {
				id: layerRepeater
				model: root.values.length

				Rectangle {
					id: segment
					required property int modelData
					property int layerIndex: modelData
					property real cumulativeHeight: {
						let sum = 0
						for (let j = 0; j < layerIndex; j++) {
							const prev = layerRepeater.itemAt(j)
							if (prev) sum += prev.height
						}
						return sum
					}
					property real opacityBase: 1
					x: 0
					y: cumulativeHeight
					width: root.barWidth
					radius: root.barRadius
					color: root.colors[layerIndex] ?? "transparent"
					opacity: opacityBase
					height: (root.values[layerIndex]?.[barItem.modelData] ?? 0) * root.scale
					Component.onCompleted: updateModulateOpacity()

					Behavior on height {
						SmoothedAnimation { duration: root.animationDuration; velocity: root.animationVelocity }
					}
					Behavior on opacityBase {
						SmoothedAnimation { duration: root.animationDuration; velocity: root.animationVelocity }
					}

					function updateModulateOpacity() {
						if (root.modulateOpacity) {
							opacityBase = Qt.binding(() => (root.values[layerIndex]?.[barItem.modelData] ?? 0) * (root.maxOpacity - root.minOpacity) + root.minOpacity)
						} else {
							opacityBase = 1
						}
					}

					Connections { target: root; function onModulateOpacityChanged() { segment.updateModulateOpacity() } }
				}
			}
		}
	}
}
