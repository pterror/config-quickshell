import QtQuick
import QtQuick.Controls
import Quickshell
import "../input"
import "../component"
import ".."

Widget {
	id: root
	required property int workspaceId
	required property int workspaceWidth
	required property int workspaceHeight
	required property var clients
	property real scale: width / workspaceWidth
	anchors.margins: 0
	color: mouseArea.containsMouse ? Config.colors.widget.hoverBg : Config.colors.widget.bg
	Behavior on color { PropertyAnimation { duration: 100 } }
	width: 200
	height: workspaceHeight * scale

	MouseArea {
		id: mouseArea
		hoverEnabled: true
		anchors.fill: parent
		cursorShape: Qt.PointingHandCursor
		onClicked: {
			HyprlandIpc.focusWorkspace(workspaceId)
			ShellIpc.workspacesOverview = false
		}
	}

	Repeater {
		model: clients

		Rectangle {
			id: rect
			required property var modelData
			x: modelData.x * root.scale
			y: modelData.y * root.scale
			width: modelData.width * root.scale
			height: modelData.height * root.scale
			radius: Config.layout.widget.radius
			color: windowMouseArea.containsMouse ? Config.colors.widget.hoverBg : Config.colors.widget.bg
			Behavior on color { PropertyAnimation { duration: 100 } }

			Button {
				anchors.fill: parent
				flat: true
				icon {
					name: modelData.class
					height: Config.layout.icon.size
					width: Config.layout.icon.size
				}
			}

			MouseArea {
				id: windowMouseArea
				hoverEnabled: true
				anchors.fill: parent
				cursorShape: Qt.PointingHandCursor
				onClicked: {
					HyprlandIpc.focusWindow("address:" + modelData.address)
					ShellIpc.workspacesOverview = false
				}
			}
		}
	}
}
