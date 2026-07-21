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
	property list<var> values: []
	property list<color> colors: []
	height: 320

	RowLayout {
		id: content
		anchors.fill: parent
		spacing: root.spacing
		property real childSize: barWidth !== -1 ? barWidth : (width + spacing) / input.count - spacing

		Repeater {
			model: input.count

			Item {
				id: barSlot
				required property int modelData
				Layout.alignment: root.childAlignment
				implicitWidth: content.childSize
				implicitHeight: stack.height

				Column {
					id: stack
					width: parent.width

					Repeater {
						model: root.colors.length

						Rectangle {
							required property int index
							property int layerIndex: root.childAlignment === Qt.AlignBottom ? (root.colors.length - 1 - index) : index
							property real value: root.values[layerIndex][barSlot.modelData]
							color: root.colors[layerIndex]
							border.color: root.strokeColor
							border.width: root.strokeWidth
							implicitHeight: value * content.height
							implicitWidth: stack.width
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
		}
	}
}
