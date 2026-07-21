import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.component
import qs.io
import qs

VisualizerBase {
	id: root
	property var barsOnRight: null
	property var childAlignment: (barsOnRight ?? anchors.right === parent.right) ? Qt.AlignRight | Qt.AlignVCenter : Qt.AlignLeft | Qt.AlignVCenter
	property int spacing: Config._.style.visualizer.gap
	property int barHeight: -1
	property int effectiveBars: input.count === -1 ? Math.floor((height + spacing) / (barHeight + spacing)) : input.count
	property int barRadius: Config._.style.rectangle.radius
	property bool modulateOpacity: false
	property real minOpacity: 0.4
	property real maxOpacity: 1.0
	property list<var> values: []
	property list<color> colors: []
	width: 480

	ColumnLayout {
		id: content
		spacing: root.spacing
		property real childSize: barHeight !== -1 ? barHeight : (height + spacing) / input.count - spacing

		Repeater {
			model: input.count

			Item {
				id: barSlot
				required property int modelData
				Layout.alignment: root.childAlignment
				implicitHeight: content.childSize
				implicitWidth: stack.width

				Row {
					id: stack
					height: parent.height

					Repeater {
						model: root.colors.length

						Rectangle {
							required property int index
							property int layerIndex: root.childAlignment === (Qt.AlignRight | Qt.AlignVCenter) ? (root.colors.length - 1 - index) : index
							property real value: root.values[layerIndex][barSlot.modelData]
							color: root.colors[layerIndex]
							border.color: root.strokeColor
							border.width: root.strokeWidth
							implicitHeight: stack.height
							implicitWidth: value * content.width
							radius: root.barRadius
							Component.onCompleted: updateModulateOpacity()

							Behavior on value {
								SmoothedAnimation { duration: root.animationDuration; velocity: root.animationVelocity }
							}

							function updateModulateOpacity() {
								if (root.modulateOpacity) {
									opacity = Qt.binding(() => root.values[layerIndex][barSlot.modelData] * (maxOpacity - minOpacity) + minOpacity)
								} else {
									opacity = 1
								}
							}

							Connections { target: root; function onModulateOpacityChanged() { updateModulateOpacity() } }
						}
					}
				}
			}
		}
	}
}
