import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
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

	// Frosted-glass bottom bar: translucent tint + hairline border + soft drop
	// shadow (it floats inset from the screen edges, so unlike the top bar there's
	// margin headroom for the shadow to render into). No backdrop blur.
	Rectangle {
		id: rootRect
		anchors.fill: parent
		anchors.margins: Config._.style.hBar.margins

		color: Config._.style.bar.bg
		radius: Config._.style.hBar.radius
		border.color: Config._.style.bar.outline
		border.width: Config._.style.hBar.border

		layer.enabled: true
		layer.effect: MultiEffect {
			shadowEnabled: true
			shadowColor: Config._.style.glass.shadowColor
			shadowBlur: Config._.style.glass.shadowBlur
			shadowVerticalOffset: Config._.style.glass.shadowVerticalOffset
			shadowHorizontalOffset: Config._.style.glass.shadowHorizontalOffset
			blurEnabled: false
		}

		RowLayout {
			implicitHeight: parent.height
			anchors.left: parent.left

			Item {
				Layout.fillHeight: true
				implicitWidth: 80
				Rectangle {
					anchors.fill: parent
					anchors.topMargin: 4
					anchors.bottomMargin: 4
					radius: Config._.style.rectangle.radius
					color: "#10e0ffff"
				}
				Rectangle {
					anchors.left: parent.left
					anchors.top: parent.top
					anchors.bottom: parent.bottom
					anchors.topMargin: 4
					anchors.bottomMargin: 4
					width: parent.width * Math.min(1, CPUInfo.activeSec / CPUInfo.totalSec)
					radius: Config._.style.rectangle.radius
					color: "#20e0ffff"
					Behavior on width { SmoothedAnimation { duration: 1000; velocity: -1 } }
				}
				Text {
					anchors.centerIn: parent
					text: (Config._.owo ? "cpuwu " : "cpu ") + Math.floor(100 * CPUInfo.activeSec / CPUInfo.totalSec) + "%"
				}
			}

			Item {
				Layout.fillHeight: true
				implicitWidth: 80
				Rectangle {
					anchors.fill: parent
					anchors.topMargin: 4
					anchors.bottomMargin: 4
					radius: Config._.style.rectangle.radius
					color: "#10e0ffff"
				}
				Rectangle {
					anchors.left: parent.left
					anchors.top: parent.top
					anchors.bottom: parent.bottom
					anchors.topMargin: 4
					anchors.bottomMargin: 4
					width: parent.width * Math.min(1, CPUInfo.iowaitFraction)
					radius: Config._.style.rectangle.radius
					color: "#20e0ffff"
					Behavior on width { SmoothedAnimation { duration: 1000; velocity: -1 } }
				}
				Text {
					anchors.centerIn: parent
					text: (Config._.owo ? "iowo " : "io ") + Math.floor(100 * CPUInfo.iowaitFraction) + "%"
				}
			}

			Item {
				Layout.fillHeight: true
				implicitWidth: 80
				Rectangle {
					anchors.fill: parent
					anchors.topMargin: 4
					anchors.bottomMargin: 4
					radius: Config._.style.rectangle.radius
					color: "#10e0ffff"
				}
				Rectangle {
					anchors.left: parent.left
					anchors.top: parent.top
					anchors.bottom: parent.bottom
					anchors.topMargin: 4
					anchors.bottomMargin: 4
					width: parent.width * Math.min(1, MemoryInfo.used / MemoryInfo.total)
					radius: Config._.style.rectangle.radius
					color: "#20e0ffff"
					Behavior on width { SmoothedAnimation { duration: 1000; velocity: -1 } }
				}
				Text {
					anchors.centerIn: parent
					text: (Config._.owo ? "mlem " : "mem ") + Math.floor(100 * MemoryInfo.used / MemoryInfo.total) + "%"
				}
			}
		}

		RowLayout {
			implicitHeight: parent.height
			anchors.centerIn: parent

			RowLayout {
				Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter

				HoverItem {
					onClicked: {
						if (!mediaControlsLoader.active) mediaControlsLoader.loading = true;
						else mediaControlsLoader.active = false;
					}

					Text {
						id: mediaText
						text: ((Config.mpris.currentPlayer?.metadata["xesam:title"] ?? "") + " - " + (Config.mpris.currentPlayer?.metadata["xesam:artist"].join(", ") ?? "")).normalize("NFKC").toLowerCase()
						LazyLoader {
							id: mediaControlsLoader
							PopupWindow {
								anchor.window: root
								anchor.rect.x: mediaText.mapToItem(rootRect, mediaText.implicitWidth / 2, 0).x - mediaControls.width / 2
								anchor.rect.y: -mediaControls.height - Config._.style.popup.gap
								extraGrabWindows: [root].concat(root.extraGrabWindows)
								visible: true
								// Keep the loader's active/loading toggle in sync when
								// HyprlandFocusGrab closes this popup via an outside click
								// (see PopupWindow.dismissed doc comment).
								onDismissed: Qt.callLater(() => mediaControlsLoader.active = false)
								MediaControls { id: mediaControls }
							}
						}
					}
				}
			}
		}

		RowLayout {
			id: rightRow
			implicitHeight: parent.height
			anchors.right: parent.right

			HoverItem {
				Layout.fillHeight: true
				onClicked: {
					if (!volumeControlsLoader.active) volumeControlsLoader.loading = true
					else volumeControlsLoader.active = false
				}

				RowLayout {
					id: volumeItem
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

					Text {
						text: Math.round(Config.services.audio.volume * 100) + "%"
						LazyLoader {
							id: volumeControlsLoader
							PopupWindow {
								extraGrabWindows: [root].concat(root.extraGrabWindows)
								anchor.window: root
								anchor.rect.x: volumeItem.mapToItem(rootRect, volumeItem.implicitWidth / 2, 0).x - volumeControls.width / 2
								anchor.rect.y: -volumeControls.height - Config._.style.popup.gap
								visible: true
								// Keep the loader's active/loading toggle in sync when
								// HyprlandFocusGrab closes this popup via an outside click
								// (see PopupWindow.dismissed doc comment).
								onDismissed: Qt.callLater(() => volumeControlsLoader.active = false)
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

					Text { id: micVolumeText; text: Math.round(Config.services.audio.micVolume * 100) + "%" }
				}
			}

				RowLayout {
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
							source: !NetworkManager.connected ? Config.iconUrl("flat/wifi_disconnected.svg") :
								NetworkManager.strength < 33 ? Config.iconUrl("flat/wifi_low.svg") :
								NetworkManager.strength < 67 ? Config.iconUrl("flat/wifi_medium.svg") :
								Config.iconUrl("flat/wifi_high.svg")
						}
					}
				Text { text: NetworkManager.network }
			}

			RowLayout {
				Layout.fillHeight: true
				implicitWidth: 72

				Text {
					width: parent.implicitWidth
					color: Config._.style.network.uploadFg
					text: NetworkInfo.uploadSecText
					horizontalAlignment: Text.AlignRight
				}
			}

			RowLayout {
				Layout.fillHeight: true
				implicitWidth: 72

				Text {
					width: parent.implicitWidth
					color: Config._.style.network.downloadFg
					text: NetworkInfo.downloadSecText
					horizontalAlignment: Text.AlignRight
				}
			}
		}
	}
}
