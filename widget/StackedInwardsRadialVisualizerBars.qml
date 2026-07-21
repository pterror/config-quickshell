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
	property int barRadius: Config._.style.rectangle.radius
	property real scale: outerRadius - innerRadius
	property real barWidth: (innerRadius * 2 * Math.PI) / input.count - 4
	property real degreesPerBar: 360 / input.count
	property bool modulateOpacity: false
	property real minOpacity: 0.4
	property real maxOpacity: 1.0
	property real rotationOffset: 0
	property list<var> values: []
	property list<color> colors: []
	width: outerRadius * 2
	height: outerRadius * 2
	inputDelegate: Cava { channels: "stereo" }

	function cumulativeValue(layer, bar) {
		let sum = 0
		for (let k = 0; k < layer; k++) sum += values[k][bar]
		return sum
	}

	Repeater {
		model: input.count

		Item {
			id: barSlot
			required property int modelData

			Repeater {
				model: root.colors.length

				Rectangle {
					required property int index
					property int layerIndex: index
					property real value: root.values[layerIndex][barSlot.modelData]
					property real cumulative: root.cumulativeValue(layerIndex, barSlot.modelData)
					property real opacityBase: 1
					opacity: opacityBase
					color: root.colors[layerIndex]
					border.color: root.strokeColor
					border.width: root.strokeWidth
					implicitHeight: value * root.scale
					implicitWidth: barWidth
					radius: root.barRadius
					property real xMultiplier: Math.cos((barSlot.modelData / input.count - 0.25 - rotationOffset / 360) * 2 * Math.PI)
					property real yMultiplier: Math.sin((barSlot.modelData / input.count - 0.25 - rotationOffset / 360) * 2 * Math.PI)
					x: root.width / 2 + (root.outerRadius - cumulative * root.scale) * xMultiplier - barWidth / 2
					y: root.height / 2 + (root.outerRadius - cumulative * root.scale) * yMultiplier
					Component.onCompleted: updateModulateOpacity()
					transform: Rotation {
						origin.x: barWidth / 2; origin.y: 0; axis { x: 0; y: 0; z: 1 }
						angle: 360 * barSlot.modelData / input.count - rotationOffset
					}

					Behavior on implicitHeight {
						SmoothedAnimation { duration: root.animationDuration; velocity: root.animationVelocity }
					}
					Behavior on opacityBase {
						SmoothedAnimation { duration: root.animationDuration; velocity: root.animationVelocity }
					}

					function updateModulateOpacity() {
						if (root.modulateOpacity) {
							opacityBase = Qt.binding(() => root.values[layerIndex][barSlot.modelData] * (maxOpacity - minOpacity) + minOpacity)
						} else {
							opacityBase = 1
						}
					}

					Connections { target: root; function onModulateOpacityChanged() { updateModulateOpacity() } }
				}
			}
		}
	}
}
