pragma Singleton

import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs
import "../component"
import ".."

Singleton {
	id: singleton
	property Component component: Component {
		Item {
			id: root
			property var modelData
			Layout.alignment: Qt.AlignTop
			Layout.fillWidth: true

			readonly property Component tabComponent: Component {
				GridLayout {
					anchors.fill: parent
					columns: 2
					rowSpacing: 8

					Repeater {
						model: Object.keys(modelDataInner)

						Text2 {
							required property int index
							required property string modelData
							Layout.alignment: Qt.AlignRight
							Layout.row: index
							Layout.column: 0
							text: modelData
						}
					}

					Repeater {
						model: Object.values(modelDataInner)

						Loader {
							required property int index
							required property var modelData
							Layout.fillWidth: true
							Layout.fillHeight: true
							Layout.row: index
							Layout.column: 1
							sourceComponent: singleton.component
							onLoaded: item.modelData = modelData
						}
					}
				}
			}

			// readonly property Component textInputComponent: Component {
			// 	TextInput {
			// 		color: Config.colors.widget.fg
			// 		font.family: Config.font.family
			// 		font.pointSize: Config.layout.widget.fontSize
			// 		text: modelDataInner.get()
			// 		onAccepted: {
			// 			modelDataInner.set(text)
			// 			text = modelDataInner.get()
			// 		}

			// 		Rectangle {
			// 			anchors.fill: parent
			// 			anchors.margins: Config.layout.hBar.margins
			// 			color: Config.colors.widget.bg
			// 			radius: Config.layout.barItem.radius
			// 		}
			// 	}
			// }

			readonly property Component textInputComponent: Component {
				Rectangle {
					anchors.margins: Config.layout.hBar.margins
					width: 80
					height: 16
					color: Config.colors.widget.bg
					radius: Config.layout.barItem.radius

					TextInput {
						anchors.fill: parent
						color: Config.colors.widget.fg
						font.family: Config.font.family
						font.pointSize: Config.layout.widget.fontSize
						horizontalAlignment: Qt.AlignHCenter
						text: modelDataInner.get()
						onAccepted: {
							modelDataInner.set(text)
							text = modelDataInner.get()
						}
					}
				}
			}


			readonly property Component numberInputComponent: Component {
				SpinBox2 {
					value: modelDataInner.get()
					onValueModified: {
						modelDataInner.set(value)
						value = modelDataInner.get()
					}
				}
			}

			readonly property Component colorInputComponent: Component {
				Item {
					Rectangle {
						id: colorDisplay
						anchors.margins: Config.layout.hBar.margins
						width: 80
						height: 16
						radius: Config.layout.barItem.radius
						color: modelDataInner.get()

						MouseArea {
							anchors.fill: parent
							cursorShape: Qt.PointingHandCursor
							onClicked: colorInput.visible = !colorInput.visible
						}

						ColorDialog {
							id: colorDialog
							selectedColor: modelDataInner.get()
							onAccepted: {
								modelDataInner.set(selectedColor)
								selectedColor = modelDataInner.get()
								colorDisplay.color = modelDataInner.get()
							}
						}
					}

					ColumnLayout2 {
						id: colorInput
						visible: false
					}
				}
			}

			readonly property Component blankComponent: Component {
				Rectangle {}
			}

			Loader {
				property var modelDataInner: modelData[1]
				sourceComponent:
					modelData[0] === "Tab" ? tabComponent :
					modelData[0] === "TextInput" ? textInputComponent :
					modelData[0] === "NumberInput" ? numberInputComponent :
					modelData[0] === "ColorInput" ? colorInputComponent :
					blankComponent
			}
		}
	}
}
