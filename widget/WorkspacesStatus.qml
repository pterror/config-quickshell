import QtQuick
import QtQuick.Layouts
import Quickshell
import "root:/io"
import "root:/component"
import "root:/"

RowLayout2 {
	autoSize: true
	Repeater {
		model: HyprlandIpc.workspaceInfosArray
		Text2 {
			Layout.minimumWidth: 13
			required property var modelData
			text: modelData.name
			color: modelData.focused
				? Config._.style.workspaceIndicator.focused
				: modelData.exists
					? Config._.style.workspaceIndicator.visible
					: Config._.style.workspaceIndicator.empty
		}
	}
}
