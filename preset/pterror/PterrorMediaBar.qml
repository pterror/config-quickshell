import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Mpris
import qs.io
import qs.component
import qs.widget
import qs

PanelWindow {
	id: root
	property list<var> extraGrabWindows: []
	anchors { left: true; right: true; bottom: true }
	implicitHeight: 32 // Config._.style.hBar.height
	color: "transparent"
	Component.onCompleted: {
		if (this.WlrLayershell) {
			this.WlrLayershell.layer = WlrLayer.Bottom
			this.WlrLayershell.namespace = "shell:bar"
		}
	}

	Rectangle {
		id: rootRect
		anchors.fill: parent
		anchors.margins: Config._.style.hBar.margins

		color: Config._.style.bar.bg
		radius: Config._.style.hBar.radius
		border.color: Config._.style.bar.outline
		border.width: Config._.style.hBar.border

		RowLayout {
			anchors.fill: parent
			RowLayout2 {
				Layout.fillHeight: true
				width: 400
				RowLayout2 {
					Layout.fillHeight: true
					width: 80
					Text2 { text: (Config._.owo ? "cpuwu " : "cpu ") + Math.floor(100 * CPUInfo.activeSec / CPUInfo.totalSec) + "%" }
				}
				RowLayout2 {
					Layout.fillHeight: true
					width: 80
					Text2 { text: (Config._.owo ? "mlem " : "mem ") + Math.floor(100 * MemoryInfo.used / MemoryInfo.total) + "%" }
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
						onClicked: {
							if (!mediaControlsLoader.active) mediaControlsLoader.loading = true;
							else mediaControlsLoader.active = false;
						}

						Text2 {
							id: mediaText
							text: ((Config.mpris.currentPlayer?.metadata["xesam:title"] ?? "") + " - " + (Config.mpris.currentPlayer?.metadata["xesam:artist"].join(", ") ?? "")).normalize("NFKC").toLowerCase()
							LazyLoader {
								id: mediaControlsLoader
								PopupWindow2 {
									anchor.window: root
									anchor.rect.x: mediaText.mapToItem(rootRect, mediaText.implicitWidth / 2, 0).x - mediaControls.width / 2
									anchor.rect.y: -mediaControls.height - Config._.style.popup.gap
									extraGrabWindows: [root].concat(root.extraGrabWindows)
									visible: true
									MediaControls { id: mediaControls }
								}
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
					onClicked: {
						if (!volumeControlsLoader.active) volumeControlsLoader.loading = true
						else volumeControlsLoader.active = false
					}

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
								opacity: Config._.iconOpacity
								source: Config.services.audio.muted ? Config.iconUrl("flat/speaker_muted.svg") :
									Config.services.audio.volume < 0.25 ? Config.iconUrl("flat/speaker_volume_very_low.svg") :
									Config.services.audio.volume < 0.50 ? Config.iconUrl("flat/speaker_volume_low.svg") :
									Config.services.audio.volume < 0.75 ? Config.iconUrl("flat/speaker_volume_medium.svg") :
									Config.iconUrl("flat/speaker_volume_high.svg")
							}
						}

						Text2 {
							text: Math.round(Config.services.audio.volume * 100) + "%"
							LazyLoader {
								id: volumeControlsLoader
								PopupWindow2 {
									extraGrabWindows: [root].concat(root.extraGrabWindows)
									anchor.window: root
									anchor.rect.x: volumeItem.mapToItem(rootRect, volumeItem.implicitWidth / 2, 0).x - volumeControls.width / 2
									anchor.rect.y: -volumeControls.height - Config._.style.popup.gap
									visible: true
									VolumeControls { id: volumeControls }
								}
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
								opacity: Config._.iconOpacity
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
							opacity: Config._.iconOpacity
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
