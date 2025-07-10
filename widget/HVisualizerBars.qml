import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.component
import qs.io
import qs

VisualizerBase {
	id: root
	property var barsOnBottom: null
	property var childAlignment: barsOnBottom ?? anchors.bottom === parent.bottom ? Qt.AlignBottom : Qt.AlignTop
	property int spacing: Config._.style.visualizer.gap
	property int barWidth: -1
	property int effectiveBars: input.count === -1 ? Math.floor((width + spacing) / (barWidth + spacing)) : input.count
	property int barRadius: Config._.style.rectangle.radius
	property bool modulateOpacity: false
	property real minOpacity: 0.4
	property real maxOpacity: 1.0
	height: 320

	RowLayout2 {
		id: content
		anchors.fill: parent
		spacing: root.spacing
		property real childSize: barWidth !== -1 ? barWidth : (width + spacing) / input.count - spacing

		Repeater {
			model: input.count

			Rectangle {
				required property int modelData
				property real value: input.values[modelData]
				Layout.alignment: root.childAlignment
				color: root.fillColor
				border.color: root.strokeColor
				border.width: root.strokeWidth
				implicitHeight: value * content.height
				implicitWidth: content.childSize
				radius: root.barRadius
				Component.onCompleted: updateModulateOpacity()

				Behavior on value {
					SmoothedAnimation { duration: root.animationDuration; velocity: root.animationVelocity }
				}

				function updateModulateOpacity() {
					if (root.modulateOpacity) {
						opacity = Qt.binding(() => value * (maxOpacity - minOpacity) + minOpacity)
					} else {
						opacity = 1
					}
				}

				Connections { target: root; function onModulateOpacityChanged() { updateModulateOpacity() } }
			}
		}
	}
}
