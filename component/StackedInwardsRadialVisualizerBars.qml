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
	// External speed input (e.g. derived from CPU load) that biases the idle drift.
	property real driftSpeed: 0
	property real rotationOffset: rotationAnim.value
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
					x: 0
					y: cumulativeHeight
					width: root.barWidth
					radius: root.barRadius
					color: root.colors[layerIndex] ?? "transparent"
					height: (root.values[layerIndex]?.[barItem.modelData] ?? 0) * root.scale

					Behavior on height {
						SmoothedAnimation { duration: root.animationDuration; velocity: root.animationVelocity }
					}
				}
			}
		}
	}

	MomentumAnimation {
		id: rotationAnim
		property real t: 0
		property int curveLength: Config._.frameRate * 1
		property list<real> opacityCurve: Array.from({ length: curveLength }, (_, i) => 0.8 + 0.2 * Math.sin(i * 2 * Math.PI / curveLength))
		property list<real> curve: Array.from({ length: curveLength }, (_, i) => -1 -.5 * Math.sin(i * 2 * Math.PI / curveLength))
		processValue: (x, frameTime) => {
			const frameDelta = frameTime * Config._.frameRate
			t = (t + frameDelta) % curveLength
			const frac = t % 1
			root.opacity = opacityCurve[Math.floor(t)] * frac + opacityCurve[Math.ceil(t) % curveLength] * (1 - frac)
			return (x + 360 + (curve[Math.floor(t)] * frac + curve[Math.ceil(t) % curveLength] * (1 - frac)) - root.driftSpeed * frameDelta) % 360
		}
	}

	MouseArea {
		id: vizMouseArea
		x: root.width / 2 - root.outerRadius
		y: root.height / 2 - root.outerRadius
		width: root.outerRadius * 2
		height: root.outerRadius * 2
		property real startAngle: 0
		property real prevAngle: 0
		property real endAngle: 0
		onPressed: { updateAngle(true); rotationAnim.velocity = 0 }
		onReleased: {
			if (endAngle - startAngle > 180) startAngle += 360
			else if (startAngle - endAngle > 180) startAngle -= 360
			rotationAnim.impulse(endAngle - startAngle)
		}
		onPositionChanged: updateAngle()

		FrameAnimation { running: true; onTriggered: vizMouseArea.startAngle = vizMouseArea.endAngle }

		function updateAngle(initial) {
			const x = mouseX - root.outerRadius
			const y = mouseY - root.outerRadius
			endAngle = Math.atan2(-y, x) * 180 / Math.PI - 90
			if (initial) {
				startAngle = endAngle
				prevAngle = endAngle
			} else {
				rotationAnim.value += endAngle - prevAngle
				prevAngle = endAngle
			}
		}

		WheelHandler {
			acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
			onWheel: event => {
				rotationAnim.impulse((event.angleDelta.x + event.angleDelta.y) / 4)
			}
		}
	}
}
