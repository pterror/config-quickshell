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
	width: outerRadius * 2
	height: outerRadius * 2
	input: Cava { channels: "stereo"; count: 40 }

	Repeater {
		model: input.count

		Rectangle {
			required property int modelData
			property real value: 0
			color: root.fillColor
			border.color: root.strokeColor
			border.width: root.strokeWidth
			implicitHeight: value * root.scale
			implicitWidth: barWidth
			radius: root.barRadius
			property real xMultiplier: Math.cos((modelData / input.count - 0.25) * 2 * Math.PI)
			property real yMultiplier: Math.sin((modelData / input.count - 0.25) * 2 * Math.PI)
			x: root.width / 2 + (root.innerRadius + implicitHeight) * xMultiplier
			y: root.height / 2 + (root.innerRadius + implicitHeight) * yMultiplier

			transform: Rotation {
				origin.x: barWidth / 2; origin.y: 0; axis { x: 0; y: 0; z: 1 }
				angle: 360 * modelData / input.count
			}

			Connections {
				target: input
				function onValue(index, newValue) {
					if (index !== modelData) return
					value = newValue
					if (modulateOpacity) {
						opacity = value * (maxOpacity - minOpacity) + minOpacity
					}
				}
			}
		}
	}
}
