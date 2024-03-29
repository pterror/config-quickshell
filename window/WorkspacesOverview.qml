import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import "../component"
import "../widget"
import ".."

PanelWindow {
	id: root
	color: "transparent"
	WlrLayershell.namespace: "shell:workspaces"
	property var monitorsData: []
	property var workspacesData: []
	property var clientsData: []
	property var workspaces: recomputeWorkspaces()
	width: content.implicitWidth
	height: content.implicitHeight

	// Required because `onVisibleChanged` does not fire on reload.
	PersistentProperties { onLoaded: reload() }

	onVisibleChanged: reload()

	RowLayout2 {
		id: content
		radius: Config.layout.panel.radius
		margins: Config.layout.widget.margins
		color: Config.colors.panel.bg
		autoSize: true

		Repeater {
			model: workspaces

			WorkspaceOverview {
				required property var modelData
				workspaceId: modelData.id
				workspaceWidth: modelData.width
				workspaceHeight: modelData.height
				clients: modelData.clients
			}
		}
	}

	Process {
		id: monitorsProcess
		command: ["hyprctl", "monitors", "-j"]
		stdout: SplitParser {
			splitMarker: ""
			onRead: json => monitorsData = JSON.parse(json)
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
		monitorsProcess.running = true
		clientsProcess.running = true
		workspacesProcess.running = true
	}

	function recomputeWorkspaces() {
		const result = Array.from({ length: 9 }, (_, i) => ({ id: i + 1, x: 0, y: 0, width: 1920, height: 1080, clients: [] }))
		for (const workspace of workspacesData) {
			const monitor = monitorsData.find(m => m.name === workspace.monitor)
			if (!monitor) continue
			const boundingBox = result[workspace.id - 1]
			if (!boundingBox) continue
			boundingBox.x = monitor.x
			boundingBox.y = monitor.y
			boundingBox.width = monitor.width
			boundingBox.height = monitor.height
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