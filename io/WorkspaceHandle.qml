import QtQuick
import qs.io

QtObject {
	id: root

	required property int workspaceId
	property string workspaceName: ""

	readonly property var workspace: {
		const byName = workspaceName
			? (Compositor.workspaces?.values?.find(value => value.name === workspaceName) ?? null)
			: null
		if (byName)
			return byName
		return Compositor.workspaces?.values?.find(value =>
			value.id === workspaceId
			|| String(value.num ?? value.number ?? "") === String(workspaceId)
			|| value.name === String(workspaceId)
		) ?? null
	}

	readonly property var monitor: workspace?.monitor ?? Compositor.focusedMonitor
	readonly property string name: workspace?.name ?? workspaceName ?? String(workspaceId)
	readonly property bool active: workspace?.active ?? workspace?.focused ?? false
	readonly property bool focused: workspace?.focused ?? active
	readonly property bool urgent: workspace?.urgent ?? false
	readonly property bool hasFullscreen: workspace?.hasFullscreen ?? false

	function activate() {
		if (workspace?.activate) {
			workspace.activate()
			return
		}
		Compositor.focusWorkspace(workspaceName || String(workspaceId))
	}
}
