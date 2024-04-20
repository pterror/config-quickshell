import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "../component"
import "../io"
import ".."

PanelWindow {
	id: root
	color: "#40000000"
	WlrLayershell.namespace: "shell:audio_visualizer"
	exclusiveZone: 0
	Component.onCompleted: {
		if (this.WlrLayershell) this.WlrLayershell.layer = WlrLayer.Bottom
	}
	property int bars: 32
	property int noiseReduction: 70
	property string channels: "stereo" // or stereo
	property string monoOption: "average" // or left or right
	property string fillColor: Config.colors.rectangle.bg
	property string strokeColor: "transparent"
	property int strokeWidth: 0
	property int outerRadius: 480
	property int innerRadius: 240
	property int barRadius: Config.layout.rectangle.radius
	property real scale: (outerRadius - innerRadius) / 128.0
	property real barWidth: (innerRadius * 2 * Math.PI) / bars - 4
	property real degreesPerBar: 360 / bars
	width: outerRadius * 2
	height: outerRadius * 2
	
	Cava {
		id: cava
		config: ({
			general: { bars: bars },
			smoothing: { noise_reduction: noiseReduction },
			output: {
				method: "raw",
				bit_format: 8,
				channels: channels,
				mono_option: monoOption,
			}
		})
	}

	Repeater {
		model: cava.count

		Rectangle {
			required property int modelData
			property int value: 0
			color: root.fillColor
			border.color: root.strokeColor
			border.width: root.strokeWidth
			implicitHeight: value * root.scale
			implicitWidth: barWidth
			radius: root.barRadius
			x: root.width / 2 + root.outerRadius * Math.cos((modelData / root.bars - 0.25) * 2 * Math.PI)
			y: root.height / 2 + root.outerRadius * Math.sin((modelData / root.bars - 0.25) * 2 * Math.PI)

			transform: Rotation {
				origin.x: barWidth / 2; origin.y: 0
				axis { x: 0; y: 0; z: 1 }
				angle: 360 * modelData / root.bars
			}

			Connections {
				target: cava
				function onValue(index, newValue) {
					if (index !== modelData) return
					value = newValue
				}
			}
		}
	}
}
