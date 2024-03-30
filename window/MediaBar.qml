import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "../input"
import "../component"
import ".."

PanelWindow {
	anchors {
		left: true
		right: true
		bottom: true
	}

	height: Config.layout.topBar.height
	color: "transparent"
	WlrLayershell.namespace: "shell:bar"

	Rectangle {
		id: barRect
		anchors {
			fill: parent
			margins: Config.layout.topBar.margins
		}

		color: Config.colors.bar.bg
		radius: Config.layout.topBar.radius
		border.color: Config.colors.bar.outline
		border.width: Config.layout.topBar.border

		RowLayout {
			anchors.fill: parent
			RowLayout2 {
				Layout.fillHeight: true
				width: 400
				RowLayout2 {
					Layout.fillHeight: true
					width: 72
					Text2 { text: "cpu " + Math.floor(100 * CPUInfo.activeSec / CPUInfo.totalSec) + "%" }
				}
				RowLayout2 {
					Layout.fillHeight: true
					width: 72
					Text2 { text: "mem " + Math.floor(100 * MemoryInfo.used / MemoryInfo.total) + "%" }
				}
				HSpace {}
			}
			RowLayout2 {
				Layout.fillHeight: true
				Layout.fillWidth: true

				RowLayout2 {
					autoSize: true
					Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
					MouseArea {
						id: mediaMouseArea
						Layout.fillHeight: true
						Layout.fillWidth: true
						implicitWidth: text.implicitWidth
						implicitHeight: text.implicitHeight
						cursorShape: Qt.PointingHandCursor
						hoverEnabled: true
						onClicked: mediaControls.visible = !mediaControls.visible
						Rectangle {
							anchors.fill: parent
							radius: Config.layout.barItem.radius
							color: mediaMouseArea.containsMouse ? Config.colors.barItem.hoverBg : Config.colors.barItem.bg
							Behavior on color { PropertyAnimation { duration: 100 } }

							Text2 {
								id: text
								text: MPRIS.title + " - " + MPRIS.artist

								MediaControls {
									id: mediaControls
									anchors.bottom: true
									visible: false
								}
							}
						}
					}
				}
			}
			RowLayout2 {
				Layout.fillHeight: true
				width: 400
				HSpace {}
				Text2 {
					text: {
						const sym = PulseAudio.muted ? "🔇" : PulseAudio.volume < 33 ? "🔈" : PulseAudio.volume < 67 ? "🔉" : "🔊"
						return sym + " " + PulseAudio.volume + "%"
					}
				}
				Text2 { text: Connman.network }
				RowLayout2 {
					Layout.fillHeight: true
					width: 48
					Text2 { color: "#a088ffaa"; text: NetworkInfo.uploadSecText }
				}
				RowLayout2 {
					Layout.fillHeight: true
					width: 48
					Text2 { color: "#a0ff88aa"; text: NetworkInfo.downloadSecText }
				}
			}
		}
	}
}