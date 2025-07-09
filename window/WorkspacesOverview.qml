import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import "root:/io"
import "root:/component"
import "root:/widget"
import "root:/"

LazyLoader {
	id: root
	property list<var> extraGrabWindows: []
	property int maxWidth: 384
	property int columns: 3
	property int rows: -1
	property int spacing: 8

	property bool shouldShow: !Config.services.compositor.isOverlaid && Config._.workspacesOverview.visible
	onShouldShowChanged: {
		if (shouldShow) loading = true
		else active = false
	}

	PanelWindow {
		id: window
		screen: Config.services.compositor.focusedScreen
		color: "transparent"
		WlrLayershell.namespace: "shell:workspaces"
		property list<var> workspacesData: []
		property list<var> workspaces: Config.services.compositor.recomputeWorkspaces()
		implicitWidth: content.implicitWidth
		implicitHeight: content.implicitHeight
		onVisibleChanged: {
			if (!visible) return
			grab.active = true
			Config.services.compositor.refetchClients()
		}

		// `onVisibleChanged` does not fire on reload
		PersistentProperties { onLoaded: Config.services.compositor.refetchClients() }

		Connections {
			target: Config._.workspacesOverview
			function onVisibleChanged() {
				grab.active = Config._.workspacesOverview.visible
			}
		}

		HyprlandFocusGrab {
			id: grab; windows: [window].concat(extraGrabWindows)
			onActiveChanged: Config._.workspacesOverview.visible = active
		}

		Rectangle {
			id: content
			color: Config._.style.workspacesOverview.bg
			radius: Config._.style.panel.radius
			implicitWidth: grid.implicitWidth + Config._.style.panel.margins * 2
			implicitHeight: grid.implicitHeight + Config._.style.panel.margins * 2

			GridLayout {
				id: grid
				anchors.fill: parent
				anchors.margins: Config._.style.panel.margins
				columns: root.columns
				rows: root.rows
				columnSpacing: root.spacing
				rowSpacing: root.spacing

				Repeater {
					model: workspaces

					WorkspaceOverview {
						required property var modelData
						width: Math.min(maxWidth, (1920 - 64) / columns)
						workspaceId: modelData.id
						workspaceWidth: modelData.width
						workspaceHeight: modelData.height
						clients: modelData.clients
					}
				}
			}
		}
	}
}
