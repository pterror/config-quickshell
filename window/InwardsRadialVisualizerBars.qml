import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "../component"
import "../io"
import ".."

VisualizerBase {
	id: root
	property int outerRadius: 480
	property int innerRadius: 240
	property int barRadius: Config.layout.rectangle.radius
	property real scale: outerRadius - innerRadius
	property real barWidth: (innerRadius * 2 * Math.PI) / input.count - 4
	property real degreesPerBar: 360 / input.count
	property bool modulateOpacity: false
	property real minOpacity: 0.4
	property real maxOpacity: 1.0
	property real rotationOffset: 0
	width: outerRadius * 2
	height: outerRadius * 2
	inputDelegate: Cava { channels: "stereo"; count: 40 }

	Repeater {
		model: input.count

		Rectangle {
			required property int modelData
			property real value: input.values[modelData]
			property real opacityBase: 1
			opacity: opacityBase * root.opacity
			color: root.fillColor
			border.color: root.strokeColor
			border.width: root.strokeWidth
			implicitHeight: value * root.scale
			implicitWidth: barWidth
			radius: root.barRadius
			x: root.width / 2 + root.outerRadius * Math.cos((modelData / input.count - 0.25 - rotationOffset / 360) * 2 * Math.PI) - barWidth / 2
			y: root.height / 2 + root.outerRadius * Math.sin((modelData / input.count - 0.25 - rotationOffset / 360) * 2 * Math.PI)
			transform: Rotation {
				origin.x: barWidth / 2; origin.y: 0; axis { x: 0; y: 0; z: 1 }
				angle: 360 * modelData / input.count - rotationOffset
			}
			Component.onCompleted: updateModulateOpacity()

			Behavior on implicitHeight {
				SmoothedAnimation { duration: root.animationDuration; velocity: root.animationVelocity }
			}
			Behavior on opacityBase {
				SmoothedAnimation { duration: root.animationDuration; velocity: root.animationVelocity }
			}

			function updateModulateOpacity() {
				if (root.modulateOpacity) {
					opacityBase = Qt.binding(() => input.values[modelData] * (maxOpacity - minOpacity) + minOpacity)
				} else {
					opacityBase = 1
				}
			}

			Connections { target: root; function onModulateOpacityChanged() { updateModulateOpacity() } }
		}
	}
}
