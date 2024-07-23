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

	property bool shouldShow: !HyprlandIpc.isOverlaid && Config.workspacesOverview.visible
	onShouldShowChanged: {
		if (shouldShow) loading = true
		else active = false
	}

	PanelWindow {
		id: window
		screen: HyprlandIpc.activeScreen
		color: "transparent"
		WlrLayershell.namespace: "shell:workspaces"
		property var workspacesData: []
		property var clientsData: []
		property var workspaces: recomputeWorkspaces()
		width: content.implicitWidth
		height: content.implicitHeight
		onVisibleChanged: {
			if (!visible) return
			grab.active = true
			reload()
		}

		// `onVisibleChanged` does not fire on reload
		PersistentProperties { onLoaded: reload() }

		Connections {
			target: Config.workspacesOverview
			function onVisibleChanged() {
				grab.active = Config.workspacesOverview.visible
			}
		}

		HyprlandFocusGrab {
			id: grab; windows: [window].concat(extraGrabWindows)
			onActiveChanged: Config.workspacesOverview.visible = active
		}

		Rectangle {
			id: content
			color: Config.colors.workspacesOverview.bg
			radius: Config.layout.panel.radius
			implicitWidth: grid.implicitWidth + Config.layout.panel.margins * 2
			implicitHeight: grid.implicitHeight + Config.layout.panel.margins * 2

			GridLayout {
				id: grid
				anchors.fill: parent
				anchors.margins: Config.layout.panel.margins
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
			HyprlandIpc.exec("j", ["clients"], json => clientsData = JSON.parse(json))
			HyprlandIpc.exec("j", ["workspaces"], json => workspacesData = JSON.parse(json))
		}

		function recomputeWorkspaces() {
			const result = HyprlandIpc.workspaceInfosArray.map((_, i) => ({ id: i + 1, x: 0, y: 0, width: 1920, height: 1080, clients: [] }))
			for (const workspace of workspacesData) {
				const screen = Quickshell.screens.find(m => m.name === workspace.monitor)
				if (!screen) continue
				const boundingBox = result[workspace.id - 1]
				if (!boundingBox) continue
				boundingBox.x = screen.x
				boundingBox.y = screen.y
				boundingBox.width = screen.width
				boundingBox.height = screen.height
				result[workspace.id - 1] = boundingBox
			}
			for (const client of clientsData) {
				const boundingBox = result[client.workspace.id - 1]
				if (!boundingBox) continue
				const info = {
					address: client.address,
					x: client.at[0] - boundingBox.x,
					y: client.at[1] - boundingBox.y,
					width: client.size[0],
					height: client.size[1],
					class: client.class,
					title: client.title,
				}
				result[client.workspace.id - 1].clients.push(info)
			}
			return result
		}
	}
}
