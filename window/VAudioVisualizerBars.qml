import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "../component"
import "../io"
import ".."

PanelWindow {
	id: root
	color: "transparent"
	WlrLayershell.namespace: "shell:audio_visualizer"
	exclusiveZone: 0
	Component.onCompleted: {
		if (this.WlrLayershell) this.WlrLayershell.layer = WlrLayer.Bottom
	}
	property var childAlignment: anchors.right ? Qt.AlignRight | Qt.AlignVCenter : Qt.AlignLeft | Qt.AlignVCenter
	property int bars: 32
	property int barHeight: -1
	property int effectiveHeight: anchors.top && anchors.bottom ? screen.height : height
	property int effectiveBars: bars === -1 ? Math.floor((effectiveHeight + spacing) / (barHeight + spacing)) : bars
	property int noiseReduction: 70
	property string channels: "mono" // or stereo
	property string monoOption: "average" // or left or right
	property string fillColor: Config.colors.rectangle.bg
	property string strokeColor: "transparent"
	property int strokeWidth: 0
	property int barRadius: Config.layout.rectangle.radius
	property bool modulateOpacity: false
	property real minOpacity: 0.4
	property real maxOpacity: 1.0
	width: 480
	
	Cava {
		id: cava
		config: ({
			general: { bars: effectiveBars },
			smoothing: { noise_reduction: noiseReduction },
			output: {
				method: "raw",
				bit_format: 8,
				channels: channels,
				mono_option: monoOption,
			}
		})
	}

	ColumnLayout2 {
		id: content
		anchors.fill: parent
		property real scale: width / 128
		property real childSize: barHeight !== -1 ? barHeight : (height + Config.layout.audioVisualizer.gap) / bars - Config.layout.audioVisualizer.gap

		Repeater {
			model: cava.count

			Rectangle {
				required property int modelData
				property int value: 0
				Layout.alignment: root.childAlignment
				color: root.fillColor
				border.color: root.strokeColor
				border.width: root.strokeWidth
				implicitHeight: content.childSize
				implicitWidth: value * content.scale
				radius: root.barRadius

				Connections {
					target: cava
					function onValue(index, newValue) {
						if (index !== modelData) return
						value = newValue
						if (modulateOpacity) {
							opacity = (value / 128) * (maxOpacity - minOpacity) + minOpacity
						}
					}
				}
			}
		}
	}
}
