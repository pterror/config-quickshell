import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
// import QtMultimedia
import "./io"
import "./component"
import "./window"
import "./library"

ShellRoot {
	WallpaperRandomizer { id: wallpaperRandomizer }

	StatBar { screen: Quickshell.screens[0] }
	MediaBar { screen: Quickshell.screens[0] }
	Greeter { screen: Quickshell.screens[0] }
	// ActivateLinux { screen: Quickshell.screens[0] }
	// SettingsWindow { screen: Quickshell.screens[0] }

	CPUInfoGrid {
		screen: Quickshell.screens[0]
		anchors.right: true
		height: 480
		width: 48
	}

	HAudioVisualizerBars {
		screen: Quickshell.screens[0]
		fillColor: Config.colors.audioVisualizer.barsBg
		bars: 48
		anchors.top: true
		anchors.left: true
		anchors.right: true
	}

	HAudioVisualizerBars {
		screen: Quickshell.screens[0]
		fillColor: Config.colors.audioVisualizer.barsBg
		bars: 48
		anchors.bottom: true
		anchors.left: true
		anchors.right: true
	}

	ScrollSpinner {
		screen: Quickshell.screens[0]
		anchors.left: true; anchors.top: true
		margins.left: 32; margins.top: 32
	}

	LazyLoader {
		id: volumeOsdLoader
		loading: Config.services.audio.initialized
		VProgressBarWindow { fraction: Config.services.audio.volume * 0.01 }
	}

	Connections {
		target: Config.services.audio
		function onVolumeChanged() {
			if (!volumeOsdLoader.active || !volumeOsdLoader.item) return
			if (volumeOsdLoader.item.screen?.id !== Hyprland.activeScreen.id) {
				volumeOsdLoader.item.screen = Hyprland.activeScreen
			}
			volumeOsdLoader.item.show()
		}
	}

	WorkspacesOverview { id: workspacesOverview }

	Connections {
		target: Shell
		function onWorkspacesOverviewChanged() {
			workspacesOverview.visible = Shell.workspacesOverview
			if (!workspacesOverview.visible) return
			if (workspacesOverview.screen.id !== Hyprland.activeScreen.id) {
				workspacesOverview.screen = Hyprland.activeScreen
			}
		}
	}

	PersistentProperties {
		onLoaded: workspacesOverview.visible = Shell.workspacesOverview
	}

	Variants {
		model: Quickshell.screens

		Scope {
			required property var modelData

			PanelWindow {
				id: window
				screen: modelData
				WlrLayershell.layer: WlrLayer.Background
				anchors { top: true; bottom: true; left: true; right: true }

				Image {
					anchors.fill: parent
					fillMode: Image.PreserveAspectCrop
					source: wallpaperRandomizer.wallpapers[modelData.name] ?? "blank.png"
					asynchronous: false
				}

				// requires QtMultimedia to be installed
				// MediaPlayer {
				// 	source: wallpaperRandomizer.wallpapers[modelData.name] ?? "blank.png"
				// 	videoOutput: videoOutput
				// 	loops: MediaPlayer.Infinite
				// 	Component.onCompleted: play()
				// 	onSourceChanged: play()
				// }

				// VideoOutput {
				// 	id: videoOutput
				// 	anchors.fill: parent
				// 	fillMode: Image.PreserveAspectCrop
				// }

				Rectangle {
					anchors.fill: parent
					color: Config.colors.backgroundBlend
				}

				// ShaderView {}

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
						target: Shell

						function onTermSelectChanged() {
							if (Shell.termSelect) {
								selectionLayer.selectionArea.startSelection(true)
							} else {
								selectionLayer.selectionArea.endSelection()
							}
						}
					}

					Connections {
						target: Hyprland

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
