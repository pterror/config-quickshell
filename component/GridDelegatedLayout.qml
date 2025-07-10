import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import qs.component
import qs.io
import qs

GridLayout {
	id: root
	property Component inputDelegate
	property var fallbackInput: Loader { active: fallbackInput === input; sourceComponent: inputDelegate }
	property var input: fallbackInput
	required property Component delegate

	height: 256
	width: 256

	columns: 4
	rows: Math.ceil(input.count / columns)

	Repeater {
		model: input.count

		Loader {
			Layout.fillHeight: true
			Layout.fillWidth: true
			required property int modelData
			property real value: input.values[modelData]
			sourceComponent: delegate
		}
	}
}
