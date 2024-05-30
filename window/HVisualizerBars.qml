import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "root:/component"
import "root:/io"
import "root:/"

VisualizerBase {
	id: root
	property var barsOnBottom: null
	property var childAlignment: barsOnBottom ?? anchors.bottom === parent.bottom ? Qt.AlignBottom : Qt.AlignTop
	property int spacing: 4
	property int barWidth: -1
	property int effectiveBars: input.count === -1 ? Math.floor((width + spacing) / (barWidth + spacing)) : input.count
	property int barRadius: Config.layout.rectangle.radius
	property bool modulateOpacity: false
	property real minOpacity: 0.4
	property real maxOpacity: 1.0
	height: 320
	inputDelegate: Cava { count: 48 }

	RowLayout2 {
		id: content
		anchors.fill: parent
		spacing: root.spacing
		property real childSize: barWidth !== -1 ? barWidth : (width + Config.layout.visualizer.gap) / input.count - Config.layout.visualizer.gap

		Repeater {
			model: input.count

			Rectangle {
				required property int modelData
				property real value: input.values[modelData]
				property real opacityBase: 1
				opacity: opacityBase
				Layout.alignment: root.childAlignment
				color: root.fillColor
				border.color: root.strokeColor
				border.width: root.strokeWidth
				implicitHeight: value * content.height
				implicitWidth: content.childSize
				radius: root.barRadius
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
}
