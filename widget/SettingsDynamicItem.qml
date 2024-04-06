import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs
import "../component"
import ".."

Item {
	id: root
	property var modelData
	Layout.alignment: Qt.AlignTop
	Layout.fillWidth: true

	readonly property Component tabComponent: Component {
		GridLayout {
			anchors.fill: parent
			columns: 2

			Repeater {
				model: Object.keys(modelDataInner[0])

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
				model: Object.values(modelDataInner[0])

				Loader {
					required property int index
					required property var modelData
					Layout.fillWidth: true
					Layout.fillHeight: true
					Layout.row: index
					Layout.column: 1
					source: "SettingsDynamicItem.qml"
					onLoaded: item.modelData = modelData
				}
			}
		}
	}

	readonly property Component textInputComponent: Component {
		TextInput {
			text: modelDataInner[0]()
			onAccepted: {
				modelDataInner[1](text)
				text = modelDataInner[0]()
			}
		}
	}

	readonly property Component numberInputComponent: Component {
		SpinBox {
			inputMethodHints: Qt.ImhFormattedNumbersOnly
			value: modelDataInner[0]()
			width: 80
			onValueModified: {
				modelDataInner[1](value)
				value = modelDataInner[0]()
			}
			background: Rectangle {
				color: Config.colors.widget.hoverBg
				radius: Config.layout.barItem.radius
			}
		}
	}

	readonly property Component colorInputComponent: Component {
		ColorDialog {
			selectedColor: modelDataInner[0]()
			onAccepted: {
				modelDataInner[1](selectedColor)
				selectedColor = modelDataInner[0]()
			}
		}
	}

	readonly property Component blankComponent: Component {
		Rectangle {}
	}

	Loader {
		property var modelDataInner: modelData.slice(1)
		sourceComponent:
			modelData[0] === "Tab" ? tabComponent :
			modelData[0] === "TextInput" ? textInputComponent :
			modelData[0] === "NumberInput" ? numberInputComponent :
			modelData[0] === "ColorInput" ? colorInputComponent :
			blankComponent
	}
}
