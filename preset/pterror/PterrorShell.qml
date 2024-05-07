import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import "../../io"
import "../../component"
import "../../window"
import "../../widget"
import "../../library"
import "../.."

ShellRoot {
	// reference `Shortcuts` so that it is loaded
	Component.onCompleted: [Shortcuts]

	WallpaperRandomizer { id: wallpaperRandomizer }
	WorkspacesOverview { extraGrabWindows: [statBar, mediaBar] }
	SystemdWLogout {}

	PterrorStatBar { id: statBar; screen: Config.screens.primary }
	PterrorMediaBar { id: mediaBar; screen: Config.screens.primary; extraGrabWindows: [statBar] }
	Greeter { screen: Config.screens.primary }
	// ActivateLinux { screen: Config.screens.primary }
	// SettingsWindow { screen: Config.screens.primary }

	Cava { id: cava; count: 48 }

	HVisualizerBars {
		screen: Config.screens.primary
		input: cava
		anchors.top: true; anchors.left: true; anchors.right: true
		modulateOpacity: true
	}

	HVisualizerBars {
		screen: Config.screens.primary
		input: cava
		anchors.bottom: true; anchors.left: true; anchors.right: true
		modulateOpacity: true; animationDuration: 1000; animationVelocity: 0.0001
	}

	InwardsRadialVisualizerBars {
		screen: Config.screens.primary
		input: CPUInfo
		innerRadius: 120; outerRadius: 220
		anchors.top: true; anchors.bottom: true; anchors.left: true; anchors.right: true
		modulateOpacity: true; animationDuration: 1000; animationVelocity: 0.0001
	}

	// CPUInfoGrid { screen: Config.screens.primary; anchors.right: true; height: 480; width: 48 }

	AnalogClock {
		screen: Config.screens.primary
		anchors.left: true; anchors.top: true
		margins.left: 32; margins.top: (screen.height - Config.layout.hBar.height - height) / 2
	}

	ScrollSpinner {
		screen: Config.screens.primary
		anchors.right: true; anchors.top: true
		margins.right: 32; margins.top: (screen.height - Config.layout.hBar.height - height) / 2
	}

	LazyLoader {
		id: volumeOsdLoader
		loading: Config.services.audio.initialized
		VProgressBarWindow {
			fraction: Config.services.audio.volume * 0.01
			onInput: fraction => Config.services.audio.setVolume(fraction * 100)
		}
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

				// VideoPlayer {
				// 	anchors.fill: parent
				// 	source: wallpaperRandomizer.wallpapers[modelData.name] ?? "../image/dark_pixel.png"
				// }

				Rectangle {
					anchors.fill: parent
					color: Config.colors.backgroundBlend
				}

				// ShaderView {}

				// WindowSpawnerSelectionArea {
				// 	app: `${Config.terminal} -e ${Config.shell}`
				// 	// app: `${Config.terminal} -e ${Config.shell} -C 'pipes.sh -RBCK -s 15 -p 3 -r 0 -f 100 | lolcat -F 0.02'`
				// }
			}
		}
	}

	// PanelWindow {
	// 	id: sussy
	// 	screen: Config.screens.primary
	// 	WlrLayershell.layer: WlrLayer.Bottom
	// 	WlrLayershell.namespace: "shell:widget"
	// 	color: "transparent"
	// 	width: crewmate.implicitWidth
	// 	height: crewmate.implicitHeight
	// 	anchors { top: true; bottom: true; left: true; right: true }
	// 	mask: Region { item: crewmate }
	// 	InteractiveCrewmate {
	// 		id: crewmate; color: "transparent"
	// 		opacity: 0.4
	// 		anchors.left: parent.left
	// 		anchors.leftMargin: 128
	// 		anchors.top: parent.top
	// 		anchors.topMargin: 64
	// 	}
	// }

	// PanelWindow {
	// 	screen: Config.screens.primary
	// 	WlrLayershell.layer: WlrLayer.Background
	// 	anchors { top: true; bottom: true; left: true; right: true }
	// 	color: "transparent"
	// 	BouncingMaskedShaderWidget {}
	// }
}
