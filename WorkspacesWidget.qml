import QtQuick
import QtQuick.Layouts
import Quickshell

RowLayout2 {
	Layout.fillWidth: true
	Layout.fillHeight: true
  Layout.horizontalStretchFactor: 1
	Repeater {
		model: HyprlandIpc.workspaceInfosArray
		Text2 {
			Layout.minimumWidth: 10
			required property var modelData
			text: modelData.name
			color: modelData.focused
				? Config.colors.workspaceIndicator.focused
				: modelData.exists
					? Config.colors.workspaceIndicator.visible
					: Config.colors.workspaceIndicator.empty
		}
	}
}
