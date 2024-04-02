import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import "../input"
import "../component"
import ".."

PanelWindow {
	id: root
	anchors { left: true; right: true; bottom: true }
	height: Config.layout.hBar.height
	color: "transparent"
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
							text: MPRIS.title + " - " + MPRIS.artist

							MediaControls {
								id: mediaControls
								relativeX: root.width / 2 - width / 2
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
					onClicked: volumeControls.visible = !volumeControls.visible
					RowLayout2 {
						id: volumeItem
						autoSize: true
						Rectangle {
							implicitWidth: speakerImage.width
							implicitHeight: rightRow.height
							color: "transparent"
							Image {
								id: speakerImage
								width: 16
								height: 16
								anchors.verticalCenter: parent.verticalCenter
								source: PulseAudio.muted ? "../image/speaker_muted.png" :
									PulseAudio.volume < 25 ? "../image/speaker_volume_very_low.png" :
									PulseAudio.volume < 50 ? "../image/speaker_volume_low.png" :
									PulseAudio.volume < 75 ? "../image/speaker_volume_medium.png" :
									"../image/speaker_volume_high.png"
							}
						}

						Text2 {
							text: PulseAudio.volume + "%"

							VolumeControls {
								id: volumeControls
								relativeY: -height - Config.layout.popup.gap
								parentWindow: root
								visible: false
								onVisibleChanged: {
									if (!visible) return
									relativeX = volumeItem.mapToItem(rootRect, volumeItem.width / 2, 0).x - width / 2
								}
							}
						}

						Rectangle { width: 0 }

						Rectangle {
							implicitWidth: micImage.width
							implicitHeight: rightRow.height
							color: "transparent"
							Image {
								id: micImage
								width: 16
								height: 16
								anchors.verticalCenter: parent.verticalCenter
								source: PulseAudio.micMuted ? "../image/microphone_muted.png" : "../image/microphone.png"
							}
						}

						Text2 { id: micVolumeText; text: PulseAudio.micVolume + "%" }
					}
				}
				// Text2 { text: Connman.network }
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
