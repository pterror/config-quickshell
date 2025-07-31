import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.io
import qs.component
import qs

RowLayout {
	id: root

	property Component component: Text {
		Layout.minimumWidth: 13
		property var workspace: Config.services.compositor.workspacesById[modelData + 1]
		visible: !Config.isSpecialWorkspace(workspace?.name);
		text: workspace?.name ?? String(modelData + 1)
		color: workspace?.focused
			? Config._.style.workspaceIndicator.focused
			: workspace?.active
				? Config._.style.workspaceIndicator.visible
				: Config._.style.workspaceIndicator.empty
	}

	Repeater {
		model: Config._.workspaceCount
		
		Loader {
			required property int modelData
			sourceComponent: root.component
		}
	}
}
