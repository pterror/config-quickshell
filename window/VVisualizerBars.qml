import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "../component"
import "../io"
import ".."

VisualizerBase {
	id: root
	property var childAlignment: anchors.right ? Qt.AlignRight | Qt.AlignVCenter : Qt.AlignLeft | Qt.AlignVCenter
	property int barHeight: -1
	property int effectiveHeight: anchors.top && anchors.bottom ? screen.height : height
	property int effectiveBars: input.count === -1 ? Math.floor((effectiveHeight + spacing) / (barHeight + spacing)) : input.count
	property int barRadius: Config.layout.rectangle.radius
	property bool modulateOpacity: false
	property real minOpacity: 0.4
	property real maxOpacity: 1.0
	width: 480

	ColumnLayout2 {
		id: content
		anchors.fill: parent
		property real childSize: barHeight !== -1 ? barHeight : (height + Config.layout.visualizer.gap) / input.count - Config.layout.visualizer.gap

		Repeater {
			model: input.count

			Rectangle {
				required property int modelData
				property real value: 0
				property real opacityBase: 1
				opacity: opacityBase * root.opacity
				Layout.alignment: root.childAlignment
				color: root.fillColor
				border.color: root.strokeColor
				border.width: root.strokeWidth
				implicitHeight: content.childSize
				implicitWidth: value * content.width
				radius: root.barRadius

				Behavior on implicitHeight {
					SmoothedAnimation { duration: root.animationDuration; velocity: root.animationVelocity }
				}
				Behavior on opacityBase {
					SmoothedAnimation { duration: root.animationDuration; velocity: root.animationVelocity }
				}

				Connections {
					target: input
					function onValue(index, newValue) {
						if (index !== modelData) return
						value = newValue
						if (modulateOpacity) {
							opacityBase = value * (maxOpacity - minOpacity) + minOpacity
						}
					}
				}
			}
		}
	}
}
