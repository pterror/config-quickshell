import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
// import QtMultimedia
import "../../io"
import "../../component"
import "../../window"
import "../../widget"
import "../../library"
import "../.."

ShellRoot {
	WallpaperRandomizer { id: wallpaperRandomizer }

	PterrorStatBar { screen: Quickshell.screens[0] }
	PterrorMediaBar { screen: Quickshell.screens[0] }
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

	// OutwardsRadialAudioVisualizerBars {
	// 	screen: Quickshell.screens[0]
	// 	fillColor: Config.colors.audioVisualizer.barsBg
	// 	bars: 40
	// 	anchors.top: true
	// 	anchors.bottom: true
	// 	anchors.left: true
	// 	anchors.right: true
	// }

	AnalogClock {
		screen: Quickshell.screens[0]
		anchors.left: true; anchors.top: true
		margins.left: 32; margins.top: (screen.height - Config.layout.hBar.height - height) / 2
	}

	ScrollSpinner {
		screen: Quickshell.screens[0]
		anchors.right: true; anchors.top: true
		margins.right: 64; margins.top: (screen.height - Config.layout.hBar.height - height) / 2
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
			if (volumeOsdLoader.item.screen?.name !== Hyprland.activeScreen.name) {
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
			if (workspacesOverview.screen.name !== Hyprland.activeScreen.name) {
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
					source: wallpaperRandomizer.wallpapers[modelData.name] ?? "../../image/dark_pixel.png"
					asynchronous: false
				}

				// requires QtMultimedia to be installed
				// MediaPlayer {
				// 	source: wallpaperRandomizer.wallpapers[modelData.name] ?? "../../image/dark_pixel.png"
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

				WindowSpawnerSelectionArea {}
			}
		}
	}
}
