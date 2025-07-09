import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import "root:/io"
import "root:/component"
import "root:/"
import "root:/library/Applications.mjs" as Applications

Widget {
	id: root
	required property int workspaceId
	required property int workspaceWidth
	required property int workspaceHeight
	required property var clients
	// visible: !Config.isSpecialWorkspace(modelData.name)
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
			Config.services.compositor.focusWorkspace(workspaceId)
			Config._.workspacesOverview.visible = false
		}
	}

	Repeater {
		model: clients

		ClippingRectangle {
			id: rect
			required property var modelData
			x: modelData.x * root.scale
			y: modelData.y * root.scale
			width: modelData.width * root.scale
			height: modelData.height * root.scale
			radius: Config._.style.widget.radius

			ScreencopyView {
				anchors.fill: parent
				captureSource: modelData.toplevel
				live: Config._.liveWindowPreviews

				Rectangle {
					anchors.fill: parent
					color: windowMouseArea.containsMouse ? Config._.style.widget.hoverBg : "transparent"
					Behavior on color { PropertyAnimation { duration: 150 } }
				}

				Image {
					readonly property int size: Math.max(1, Math.min(parent.height, parent.width, Config._.style.icon.size))
					anchors.verticalCenter: parent.verticalCenter
					anchors.horizontalCenter: parent.horizontalCenter
					source: Quickshell.iconPath(Applications.guessIcon(modelData.class))
					width: size
					height: size
					sourceSize: Qt.size(width, height)
					cache: false
				}
			}

			MouseArea {
				id: windowMouseArea
				hoverEnabled: true
				anchors.fill: parent
				cursorShape: Qt.PointingHandCursor
				onClicked: {
					Config.services.compositor.focusWindow("address:" + modelData.address)
					Config._.workspacesOverview.visible = false
				}
			}
		}
	}
}
