import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

ShellRoot {
	WallpaperRandomizer { id: wallpaperRandomizer }

	StatBar { screen: Quickshell.screens[0] }
	MediaBar { screen: Quickshell.screens[0] }

	VProgressBar {
		id: volumeOsd
		fraction: PulseAudio.volume * 0.01
	}

	Connections {
		target: PulseAudio
		function onVolumeChanged() {
			volumeOsd.screen = HyprlandIpc.activeScreen
			volumeOsd.show()
		}
	}

	Variants {
		model: Quickshell.screens

		Scope {
			property var modelData

			PanelWindow {
				id: window

				screen: modelData
				WlrLayershell.layer: WlrLayer.Background

				anchors {
					top: true
					bottom: true
					left: true
					right: true
				}

				Image {
					anchors.fill: parent
					fillMode: Image.PreserveAspectCrop
					source: wallpaperRandomizer.wallpapers[modelData.name] ?? "blank.png"
					asynchronous: false
				}

				SelectionLayer {
					id: selectionLayer

					onSelectionComplete: (x, y, width, height) => {
						termSpawner.x = x
						termSpawner.y = y
						termSpawner.width = width
						termSpawner.height = height
						termSpawner.running = true
					}

					Process {
						id: termSpawner
						property real x
						property real y
						property real width
						property real height

						command: [
							"hyprctl",
							"dispatch",
							"exec",
							`[float;; noanim; move ${x} ${y}; size ${width} ${height}] alacritty --class AlacrittyTermselect`
						]
					}

					Connections {
						target: ShellIpc

						function onTermSelectChanged() {
							if (ShellIpc.termSelect) {
								selectionLayer.selectionArea.startSelection(true)
							} else {
								selectionLayer.selectionArea.endSelection()
							}
						}
					}

					Connections {
						target: HyprlandIpc

						function onWindowOpened(_, _, klass, _) {
							if (klass === "AlacrittyTermselect") {
								selectionLayer.selectionArea.selecting = false
							}
						}
					}
				}

				SelectionArea {
					anchors.fill: parent
					screen: window.screen
					selectionArea: selectionLayer.selectionArea
				}
			}
		}
	}
}
