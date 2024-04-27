import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import "../io"
import "../component"
import "../widget"
import ".."

PanelWindow {
	id: root
	color: "transparent"
	WlrLayershell.namespace: "shell:workspaces"
	property var workspacesData: []
	property var clientsData: []
	property var workspaces: recomputeWorkspaces()
	property int maxWidth: 384
	property int columns: 3
	property int rows: -1
	property int spacing: 8
	width: content.implicitWidth
	height: content.implicitHeight

	// Required because `onVisibleChanged` does not fire on reload.
	PersistentProperties { onLoaded: reload() }

	onVisibleChanged: reload()

	Rectangle {
		id: content
		color: Config.colors.panel.bg
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

	Process {
		id: workspacesProcess
		command: ["hyprctl", "workspaces", "-j"]
		stdout: SplitParser {
			splitMarker: ""
			onRead: json => workspacesData = JSON.parse(json)
		}
	}

	Process {
		id: clientsProcess
		command: ["hyprctl", "clients", "-j"]
		stdout: SplitParser {
			splitMarker: ""
			onRead: json => clientsData = JSON.parse(json)
		}
	}

	function reload() {
		clientsProcess.running = true
		workspacesProcess.running = true
	}

	function recomputeWorkspaces() {
		const result = Hyprland.workspaceInfosArray.map((_, i) => ({ id: i + 1, x: 0, y: 0, width: 1920, height: 1080, clients: [] }))
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
