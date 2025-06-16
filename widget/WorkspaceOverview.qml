import QtQuick
import QtQuick.Controls
import Quickshell
import "root:/io"
import "root:/component"
import "root:/"

Widget {
	id: root
	required property int workspaceId
	required property int workspaceWidth
	required property int workspaceHeight
	required property var clients
	property real scale: width / workspaceWidth
	anchors.margins: 0
	color: mouseArea.containsMouse ? Config._.style.widget.hoverBg : Config._.style.widget.bg
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
			Config._.workspacesOverview.visible = false
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
			radius: Config._.style.widget.radius
			color: windowMouseArea.containsMouse ? Config._.style.widget.hoverBg : Config._.style.widget.bg
			Behavior on color { PropertyAnimation { duration: 100 } }

			Image {
				readonly property int size: Math.max(1, Math.min(parent.height, parent.width, Config._.style.icon.size))
				anchors.verticalCenter: parent.verticalCenter
				anchors.horizontalCenter: parent.horizontalCenter
				source: "image://icon/" + modelData.class
				width: size; height: size
				sourceSize: Qt.size(width, height)
				cache: false
			}

			MouseArea {
				id: windowMouseArea
				hoverEnabled: true
				anchors.fill: parent
				cursorShape: Qt.PointingHandCursor
				onClicked: {
					HyprlandIpc.focusWindow("address:" + modelData.address)
					Config._.workspacesOverview.visible = false
				}
			}
		}
	}
}
