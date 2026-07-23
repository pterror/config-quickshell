import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import qs.io
import qs.component
import qs
import "root:/library/Applications.mjs" as Applications

Widget {
	id: root
	required property int workspaceId
	property string workspaceName: ""
	required property int workspaceWidth
	required property int workspaceHeight
	required property var clients
	property bool special: false
	property real scale: width / workspaceWidth
	anchors.margins: 0
	color: mouseArea.containsMouse ? Config._.style.widget.hoverBg : Config._.style.widget.bg
	border.color: special ? Config._.style.workspacesOverview.specialOutline : Config._.style.widget.outline
	border.width: special ? Config._.style.workspacesOverview.specialBorder : Config._.style.widget.border
	Behavior on color { PropertyAnimation { duration: 100 } }
	width: 200
	height: workspaceHeight * scale

	Text {
		visible: special
		text: root.workspaceName.replace(/^special:/i, "")
		color: Config._.style.workspacesOverview.specialOutline
		anchors.top: parent.top
		anchors.left: parent.left
		anchors.margins: 2
		font.pixelSize: Config._.style.widget.fontSize
		z: 1
	}

	MouseArea {
		id: mouseArea
		hoverEnabled: true
		anchors.fill: parent
		cursorShape: Qt.PointingHandCursor
		onClicked: {
			Config.services.compositor.focusWorkspace(special ? workspaceName : String(workspaceId));
			Config._.workspacesOverview.visible = false;
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
					WindowIndex.focusWindow(modelData.address)
					Config._.workspacesOverview.visible = false
				}
			}
		}
	}
}
