import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import "root:/io"
import "root:/component"
import "root:/window"
import "root:/widget"
import "root:/library"
import "root:/"

ShellRoot {
	// reference `Shortcuts` so that it is loaded
	Component.onCompleted: [Shortcuts]

	WallpaperRandomizer { id: wallpaperRandomizer }
	WorkspacesOverview { extraGrabWindows: [statBar, mediaBar] }
	SystemdWLogout {}

	Cava { id: cava; count: 48 }

	PterrorStatBar { id: statBar; screen: Config.screens.primary }
	PterrorMediaBar { id: mediaBar; screen: Config.screens.primary; extraGrabWindows: [statBar] }

	LazyLoader {
		id: volumeOsdLoader
		loading: Config.services.audio.initialized
		VProgressBarWindow {
			anchors.right: true
			fraction: Config.services.audio.volume
			onInput: fraction => Config.services.audio.setVolume(fraction)
		}
	}

	Connections {
		target: Config.services.audio
		function onVolumeChanged() {
			if (!volumeOsdLoader.active || !volumeOsdLoader.item) return
			const compositor = Config.services.compositor
			if (compositor.focusedScreen && volumeOsdLoader.item.screen?.name !== compositor.focusedScreen.name) {
				volumeOsdLoader.item.screen = compositor.focusedScreen
			}
			volumeOsdLoader.item.show()
		}
	}

	Variants {
		model: Quickshell.screens

		Scope {
			required property var modelData

			// PanelWindow {
			// 	screen: modelData
			// 	aboveWindows: true
			// 	color: "transparent"
			// 	mask: Region { item: Rectangle {} }
			// 	anchors.left: true; anchors.right: true; anchors.top: true; anchors.bottom: true
			// 	exclusionMode: ExclusionMode.Ignore
			// 	Rectangle {
			// 		anchors.fill: parent
			// 		color: "#40800000"
			// 	}
			// }

			PanelWindow {
				id: window
				color: "transparent"
				screen: modelData
				Component.onCompleted: {
					if (this.WlrLayershell) {
						this.WlrLayershell.layer = WlrLayer.Background
					}
				}
				anchors { top: true; bottom: true; left: true; right: true }

				Wallpaper {
					source: wallpaperRandomizer.wallpapers[modelData.name] ?? Config.imageUrl("dark_pixel.png")
					layer.enabled: Config.wallpapers.effect != null
					layer.effect: Config.wallpapers.effect
				}

				// CrankableImage {
				// 	screen: modelData
				// 	source: wallpaperRandomizer.wallpapers[modelData.name] ?? Config.imageUrl("dark_pixel.png")
				// 	layer.enabled: Config.wallpapers.effect != null
				// 	layer.effect: Config.wallpapers.effect
				// }

				// VideoPlayer {
				// 	anchors.fill: parent
				// 	source: wallpaperRandomizer.wallpapers[modelData.name] ?? Config.imageUrl("dark_pixel.png")
				// }

				// ShaderView {}

				// HyprlandWindowSpawnerSelectionArea {
				// 	app: `${Config._.terminal} -e ${Config._.shell} -C 'nix run nixpkgs#pipes -- -RBCK -s 15 -p 3 -r 0 -f 100 | nix run nixpkgs#lolcat -- -F 0.02'`
				// }

				// GridDelegatedLayout {
				// 	input: CPUInfo
				// 	delegate: VProgressBar {
				// 		color: "transparent"
				// 		margins: 0
				// 		innerRadius: Config._.style.rectangle.radius
				// 		fg: Config._.style.rectangle.bg
				// 		animationDuration: CPUInfo.interval
				// 		anchors.fill: parent
				// 		fraction: value
				// 	}
				// }
			}
		}
	}

	Variants {
		model: Config._.widgetsAcrossAllScreens ? Quickshell.screens : [Config.screens.primary]

		Scope {
			required property var modelData

			PanelWindow {
				screen: modelData
				anchors.left: true; anchors.right: true; anchors.top: true; anchors.bottom: true
				color: "transparent"
				WlrLayershell.layer: WlrLayer.Bottom

				HVisualizerBars {
					input: cava
					anchors.top: parent.top; anchors.left: parent.left; anchors.right: parent.right
					modulateOpacity: true
				}

				HVisualizerBars {
					input: cava
					anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.right: parent.right
					modulateOpacity: true
				}

				CPUBars {}

				// TimeZonesDisplay {}

				// PanelWindow {
				// 	screen: Config.screens.primary
				// 	color: "transparent"
				// 	WlrLayershell.layer: WlrLayer.Bottom
				// 	width: radialLauncher.implicitWidth || 1
				// 	height: radialLauncher.implicitHeight || 1
				// 	RadialLauncher { id: radialLauncher }
				// }

				Greeter {
					anchors.horizontalCenter: parent.horizontalCenter
					anchors.verticalCenter: parent.verticalCenter
				}

				ActivateLinux {}

				AnalogClock {
					anchors.left: parent.left; anchors.top: parent.top
					anchors.leftMargin: 32
					anchors.topMargin: (parent.height - Config._.style.hBar.height - height) / 2
				}

				ScrollSpinner {
					anchors.right: parent.right; anchors.top: parent.top
					anchors.rightMargin: 32
					anchors.topMargin: (parent.height - Config._.style.hBar.height - height) / 2
				}

				InteractiveCrewmate {
					visible: Screen.name === Config.screens.primary.name
					color: "transparent"
					maxClickCount: 2
					opacity: 0.4
					anchors.left: parent.left
					anchors.leftMargin: 128
					anchors.top: parent.top
					anchors.topMargin: 64
				}

				BouncingMaskedShaderWidget {
					visible: Screen.name === Config.screens.primary.name
					id: bouncingMaskedShader
					moving: !bouncingMaskedShaderMouseArea.containsPress
				}

				MouseArea {
					id: bouncingMaskedShaderMouseArea
					property int startX: 0
					property int startY: 0
					anchors.fill: bouncingMaskedShader
					cursorShape: Qt.PointingHandCursor
					onPressed: event => { startX = event.x; startY = event.y }
					onPositionChanged: event => {
						const dx = event.x - startX
						const dy = event.y - startY
						bouncingMaskedShader.x += dx
						bouncingMaskedShader.y += dy
						bouncingMaskedShader.impulse(Math.hypot(dy, dx) * 10)
						bouncingMaskedShader.angle = Math.atan2(dy, dx) * 180 / Math.PI
					}
				}
			}
		}
	}
}
