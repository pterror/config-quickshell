import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import qs.io
import qs.component
import qs.window
import qs.widget
import qs
import qs.models3d

ShellRoot {
	// reference `Shortcuts` so that it is loaded
	Component.onCompleted: [Shortcuts]

	WallpaperRandomizer { id: wallpaperRandomizer }
	WorkspacesOverview { extraGrabWindows: [statBar, mediaBar] }
	SystemdWLogout {}
	WidgetOverlay { extraGrabWindows: [statBar, mediaBar] }

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
				// Ignore the bars' exclusive zones: they reserve screen space so
				// tiled app windows leave room for them, but this background layer
				// must still paint the full screen underneath — otherwise the strip
				// they reserve goes unpainted by this layer, and since the bars
				// (PterrorStatBar/PterrorMediaBar) are now translucent + rounded
				// (config/ConfigBase.qml `style.glass`) rather than opaque + square,
				// that gap shows through as a non-rounded dark rectangle behind them.
				exclusionMode: ExclusionMode.Ignore
				Component.onCompleted: {
					if (this.WlrLayershell) {
						this.WlrLayershell.layer = WlrLayer.Background
					}
				}
				anchors { top: true; bottom: true; left: true; right: true }

				// Wallpaper {
				// 	source: wallpaperRandomizer.wallpapers[modelData.name] ?? Config.imageUrl("dark_pixel.png")
				// 	layer.enabled: Config.wallpapers.effect != null
				// 	layer.effect: Config.wallpapers.effect
				// }

				// PanoramaViewer {
				// 	source: wallpaperRandomizer.wallpapers[modelData.name] ?? Config.imageUrl("dark_pixel.png")
				// 	layer.enabled: Config.wallpapers.effect != null
				// 	layer.effect: Config.wallpapers.effect
				// }

				Viewer3D {
					anchors.fill: parent
					BitterMajesty {}
					clearColor: "#a351a4"
					cameraX: 0
					cameraY: 35
					cameraZ: 105
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
				mask: Region {
					item: cpuBars
					shape: RegionShape.Ellipse
					Region { item: clock; shape: RegionShape.Ellipse }
					Region { item: amogus }
					Region { item: fidgetSpinner; shape: RegionShape.Ellipse }
					// Region { item: bouncingMaskedShader }
				}
				anchors.left: true; anchors.right: true; anchors.top: true; anchors.bottom: true
				color: "transparent"
				WlrLayershell.layer: WlrLayer.Bottom

				HVisualizerBars {
					input: cava
					anchors.top: parent.top; anchors.left: parent.left; anchors.right: parent.right
					margins: Config._.style.hBar.margins
					modulateOpacity: true
				}

				HVisualizerBars {
					input: cava
					anchors.bottom: parent.bottom; anchors.left: parent.left; anchors.right: parent.right
					margins: Config._.style.hBar.margins
					modulateOpacity: true
				}

				InwardsRadialVisualizerBars {
					id: cpuBars
					input: CPUInfo
					outerRadius: 220
					innerRadius: 120
					rotationOffset: cpuVizAnimLoader.item?.value ?? 0
					anchors.horizontalCenter: parent.horizontalCenter
					anchors.verticalCenter: parent.verticalCenter

					Loader {
						id: cpuVizAnimLoader
						active: !Config._.reducedMotion
						sourceComponent: MomentumAnimation {
							id: cpuVizAnim
							property real t: 0
							property int curveLength: Config._.frameRate * 1
							property real speedFromCpuUsage: (1 - CPUInfo.idleSec / CPUInfo.totalSec) / 0.1
							property list<real> opacityCurve: Array.from({ length: curveLength }, (_, i) => 0.8 + 0.2 * Math.sin(i * 2 * Math.PI / curveLength))
							property list<real> curve: Array.from({ length: curveLength }, (_, i) => -1 - 0.5 * Math.sin(i * 2 * Math.PI / curveLength))
							processValue: (x, frameTime) => {
								const frameDelta = frameTime * Config._.frameRate
								t = (t + frameDelta) % curveLength
								const frac = t % 1
								cpuBars.opacity = opacityCurve[Math.floor(t)] * frac + opacityCurve[Math.ceil(t) % curveLength] * (1 - frac)
								return (x + 360 + (curve[Math.floor(t)] * frac + curve[Math.ceil(t) % curveLength] * (1 - frac)) - speedFromCpuUsage * frameDelta) % 360
							}
						}
						onActiveChanged: if (!active) cpuBars.opacity = 1
					}

					Loader {
						id: cpuVizMouseAreaLoader
						active: !Config._.reducedMotion
						sourceComponent: MouseArea {
							id: cpuVizMouseArea
							x: cpuBars.width / 2 - cpuBars.outerRadius
							y: cpuBars.height / 2 - cpuBars.outerRadius
							width: cpuBars.outerRadius * 2
							height: cpuBars.outerRadius * 2
							property real startAngle: 0
							property real prevAngle: 0
							property real endAngle: 0
							onPressed: { updateAngle(true); cpuVizAnimLoader.item.velocity = 0 }
							onReleased: {
								if (endAngle - startAngle > 180) startAngle += 360
								else if (startAngle - endAngle > 180) startAngle -= 360
								cpuVizAnimLoader.item.impulse(endAngle - startAngle)
							}
							onPositionChanged: updateAngle()

							FrameAnimation { running: true; onTriggered: cpuVizMouseArea.startAngle = cpuVizMouseArea.endAngle }

							function updateAngle(initial) {
								const x = mouseX - cpuBars.outerRadius
								const y = mouseY - cpuBars.outerRadius
								endAngle = Math.atan2(-y, x) * 180 / Math.PI - 90
								if (initial) {
									startAngle = endAngle
									prevAngle = endAngle
								} else {
									cpuVizAnimLoader.item.value += endAngle - prevAngle
									prevAngle = endAngle
								}
							}

							WheelHandler {
								acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
								onWheel: event => {
									cpuVizAnimLoader.item.impulse((event.angleDelta.x + event.angleDelta.y) / 4)
								}
							}
						}
					}
				}

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
					id: clock
					anchors.left: parent.left; anchors.top: parent.top
					anchors.leftMargin: 32
					anchors.topMargin: (parent.height - Config._.style.hBar.height - height) / 2
				}

				ScrollSpinner {
					id: fidgetSpinner
					anchors.right: parent.right; anchors.top: parent.top
					anchors.rightMargin: 32
					anchors.topMargin: (parent.height - Config._.style.hBar.height - height) / 2
				}

				InteractiveCrewmate {
					id: amogus
					visible: Screen.name === Config.screens.primary.name
					color: "transparent"
					maxClickCount: 2
					opacity: 0.4
					anchors.left: parent.left
					anchors.leftMargin: 128
					anchors.top: parent.top
					anchors.topMargin: 64
				}

				Loader {
					id: bouncingMaskedShaderLoader
					anchors.fill: parent
					active: !Config._.reducedMotion
					sourceComponent: BouncingMaskedShader {
						visible: Screen.name === Config.screens.primary.name
						id: bouncingMaskedShader
						moving: !bouncingMaskedShaderMouseArea.containsPress

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
	}
}
