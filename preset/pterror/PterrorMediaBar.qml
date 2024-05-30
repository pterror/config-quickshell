import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Mpris
import "../../io"
import "../../component"
import "../../window"
import "../.."

PanelWindow {
	id: root
	property list<var> extraGrabWindows: []
	anchors { left: true; right: true; bottom: true }
	height: Config.layout.hBar.height
	color: "transparent"
	WlrLayershell.layer: WlrLayer.Bottom
	WlrLayershell.namespace: "shell:bar"

	Rectangle {
		id: rootRect
		anchors {
			fill: parent
			margins: Config.layout.hBar.margins
		}

		color: Config.colors.bar.bg
		radius: Config.layout.hBar.radius
		border.color: Config.colors.bar.outline
		border.width: Config.layout.hBar.border

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

					HoverItem {
						inner: mediaText
						onClicked: mediaControls.visible = !mediaControls.visible

						Text2 {
							id: mediaText
							text: (Config.mpris.currentPlayer?.metadata["xesam:title"] ?? "") + " - " + (Config.mpris.currentPlayer?.metadata["xesam:artist"].join(", ") ?? "")
							MediaControls {
								id: mediaControls
								extraGrabWindows: [root].concat(root.extraGrabWindows)
								relativeX: mediaText.mapToItem(rootRect, mediaText.implicitWidth / 2, 0).x - width / 2
								relativeY: -height - Config.layout.popup.gap
								parentWindow: root
								visible: false
							}
						}
					}
				}
			}
			RowLayout2 {
				id: rightRow
				Layout.fillHeight: true
				width: 400
				HSpace {}
				HoverItem {
					inner: volumeItem
					Layout.fillHeight: true
					onClicked: volumeControls.visible = !volumeControls.visible

					RowLayout2 {
						id: volumeItem
						autoSize: true
						Rectangle {
							implicitWidth: speakerImage.width
							implicitHeight: speakerImage.height
							color: "transparent"
							Image {
								id: speakerImage
								width: 16
								height: 16
								anchors.verticalCenter: parent.verticalCenter
								opacity: Config.iconOpacity
								source: Config.services.audio.muted ? Config.iconUrl("flat/speaker_muted.svg") :
									Config.services.audio.volume < 0.25 ? Config.iconUrl("flat/speaker_volume_very_low.svg") :
									Config.services.audio.volume < 0.50 ? Config.iconUrl("flat/speaker_volume_low.svg") :
									Config.services.audio.volume < 0.75 ? Config.iconUrl("flat/speaker_volume_medium.svg") :
									Config.iconUrl("flat/speaker_volume_high.svg")
							}
						}

						Text2 {
							text: Math.round(Config.services.audio.volume * 100) + "%"
							VolumeControls {
								id: volumeControls
								extraGrabWindows: [root].concat(root.extraGrabWindows)
								relativeX: volumeItem.mapToItem(rootRect, volumeItem.implicitWidth / 2, 0).x - width / 2
								relativeY: -height - Config.layout.popup.gap
								parentWindow: root
								visible: false
							}
						}

						Rectangle { width: 0 }

						Rectangle {
							implicitWidth: micImage.width
							implicitHeight: micImage.height
							color: "transparent"
							Image {
								id: micImage
								width: 16
								height: 16
								anchors.verticalCenter: parent.verticalCenter
								opacity: Config.iconOpacity
								source: Config.services.audio.micMuted ? Config.iconUrl("flat/microphone_muted.svg") : Config.iconUrl("flat/microphone.svg")
							}
						}

						Text2 { id: micVolumeText; text: Math.round(Config.services.audio.micVolume * 100) + "%" }
					}
				}
				RowLayout2 {
					autoSize: true
					Rectangle {
						implicitWidth: wifiImage.width
						implicitHeight: wifiImage.height
						color: "transparent"
						Image {
							id: wifiImage
							width: 16
							height: 16
							anchors.verticalCenter: parent.verticalCenter
							opacity: Config.iconOpacity
							source: !Config.services.network.connected ? Config.iconUrl("flat/wifi_disconnected.svg") :
								Config.services.network.strength < 33 ? Config.iconUrl("flat/wifi_low.svg") :
								Config.services.network.strength < 67 ? Config.iconUrl("flat/wifi_medium.svg") :
								Config.iconUrl("flat/wifi_high.svg")
					}
					}
					Text2 { text: Config.services.network.network }
				}
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
