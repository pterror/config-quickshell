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

			readonly property Component textInputComponent: Component {
				TextInput {
					text: modelDataInner.get()
					onAccepted: {
						modelDataInner.set(text)
						text = modelDataInner.get()
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
				ColorDialog {
					selectedColor: modelDataInner.get()
					onAccepted: {
						modelDataInner.set(selectedColor)
						selectedColor = modelDataInner.get()
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
