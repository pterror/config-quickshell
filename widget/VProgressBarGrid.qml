import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import "root:/component"
import "root:/io"
import "root:/"

GridLayout {
	id: root
	property real animationDuration: 0
	property real animationVelocity: 1
	required property Component inputDelegate
	property var fallbackInput: Loader { active: fallbackInput === input; sourceComponent: inputDelegate }
	property var input: fallbackInput

	columns: 4
	rows: Math.ceil(input.count / columns)

	Repeater {
		model: input.count

		VProgressBar {
			required property int modelData
			Layout.fillHeight: true
			Layout.fillWidth: true
			animationDuration: root.animationDuration
			animationVelocity: root.animationVelocity
			fraction: input.values[modelData]
			radius: 0
			margins: 0
			innerRadius: Config.layout.rectangle.radius
			color: "transparent"
			fg: Config.colors.rectangle.bg
		}
	}
}
