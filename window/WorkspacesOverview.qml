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
		property list<var> clientsData: []
		property list<var> workspaces: recomputeWorkspaces()
		implicitWidth: content.implicitWidth
		implicitHeight: content.implicitHeight
		onVisibleChanged: {
			if (!visible) return
			grab.active = true
			reload()
		}

		// `onVisibleChanged` does not fire on reload
		PersistentProperties { onLoaded: reload() }

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

		function reload() {
			Config.services.compositor.exec("j", ["clients"], json => { clientsData = JSON.parse(json); });
		}

		function recomputeWorkspaces() {
			const result = Array.from({ length: Config._.workspaceCount }, (_, i) => ({
				id: i, x: 0, y: 0, width: 1920, height: 1080, clients: [],
			}));
			for (const workspace of Config.services.compositor.workspaces.values) {
				if (!/^\d+$/.test(workspace.name)) continue;
				const screen = Quickshell.screens.find(m => m.name === workspace.monitor.name);
				result[workspace.id - 1] = {
					id: workspace.id,
					x: screen?.x ?? 0,
					y: screen?.y ?? 0,
					width: screen?.width ?? 1920,
					height: screen?.height ?? 1080,
					clients: [],
				};
			}
			for (const client of clientsData) {
				const boundingBox = result[client.workspace.id - 1];
				if (!boundingBox) continue;
				const info = {
					address: client.address,
					x: client.at[0] - boundingBox.x,
					y: client.at[1] - boundingBox.y,
					width: client.size[0],
					height: client.size[1],
					class: client.class,
					title: client.title,
					toplevel: ToplevelManager.toplevels.values.find(value => `0x${value.HyprlandToplevel?.address}` === client.address),
				}
				result[client.workspace.id - 1].clients.push(info);
			}
			return result;
		}
	}
}
