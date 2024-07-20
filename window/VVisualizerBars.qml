import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "root:/component"
import "root:/io"
import "root:/"

VisualizerBase {
	id: root
	property var barsOnRight: null
	property var childAlignment: (barsOnRight ?? anchors.right === parent.right) ? Qt.AlignRight | Qt.AlignVCenter : Qt.AlignLeft | Qt.AlignVCenter
	property int barHeight: -1
	property int effectiveBars: input.count === -1 ? Math.floor((height + spacing) / (barHeight + spacing)) : input.count
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
				property real value: input.values[modelData]
				Layout.alignment: root.childAlignment
				color: root.fillColor
				border.color: root.strokeColor
				border.width: root.strokeWidth
				implicitHeight: content.childSize
				implicitWidth: value * content.width
				radius: root.barRadius
				Component.onCompleted: updateModulateOpacity()

				Behavior on value {
					SmoothedAnimation { duration: root.animationDuration; velocity: root.animationVelocity }
				}

				function updateModulateOpacity() {
					if (root.modulateOpacity) {
						opacity = Qt.binding(() => input.values[modelData] * (maxOpacity - minOpacity) + minOpacity)
					} else {
						opacity = 1
					}
				}

				Connections { target: root; function onModulateOpacityChanged() { updateModulateOpacity() } }
			}
		}
	}
}
