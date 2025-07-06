import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
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

	function guessIcon(name: string): string {
		// See https://github.com/end-4/dots-hyprland/blob/9d6452aaaf3723f2fcce38fdd90e62168e41bb3f/.config/quickshell/services/AppSearch.qml#L17-L27
		return {
        "code-url-handler": "visual-studio-code",
        "Code": "visual-studio-code",
        "gnome-tweaks": "org.gnome.tweaks",
        "pavucontrol-qt": "pavucontrol",
        "wps": "wps-office2019-kprometheus",
        "wpsoffice": "wps-office2019-kprometheus",
        "footclient": "foot",
        "zen": "zen-browser",
        "brave-browser": "brave-desktop"
    }[name] ?? name;
	}

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
			color: "transparent"

			Rounded {
				enabled: true
				implicitWidth: parent.width
				implicitHeight: parent.height
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
						source: Quickshell.iconPath(guessIcon(modelData.class))
						width: size
						height: size
						sourceSize: Qt.size(width, height)
						cache: false
					}
				}
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
