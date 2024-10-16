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

	PterrorStatBar { id: statBar; screen: Config.screens.primary }
	PterrorMediaBar { id: mediaBar; screen: Config.screens.primary; extraGrabWindows: [statBar] }

	LazyLoader {
		id: volumeOsdLoader
		loading: Config.services.audio.initialized
		FadingWindow {
			width: 64; height: 240
			anchors.right: true
			VProgressBar {
				anchors.fill: parent; anchors.margins: 8
				fraction: Config.services.audio.volume
				onInput: fraction => Config.services.audio.setVolume(fraction)
			}
		}
	}

	Connections {
		target: Config.services.audio
		function onVolumeChanged() {
			if (!volumeOsdLoader.active || !volumeOsdLoader.item) return
			if (HyprlandIpc.activeScreen && volumeOsdLoader.item.screen?.name !== HyprlandIpc.activeScreen.name) {
				volumeOsdLoader.item.screen = HyprlandIpc.activeScreen
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
				screen: modelData
				Component.onCompleted: {
					if (this.WlrLayershell) {
						this.WlrLayershell.layer = WlrLayer.Background
					}
				}
				anchors { top: true; bottom: true; left: true; right: true }

				color: "transparent"

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

				// WindowSpawnerSelectionArea {
				// 	app: `${Config.terminal} -e ${Config.shell} -C 'pipes.sh -RBCK -s 15 -p 3 -r 0 -f 100 | lolcat -F 0.02'`
				// }

				// GridDelegatedLayout {
				// 	input: CPUInfo
				// 	delegate: VProgressBar {
				// 		color: "transparent"
				// 		margins: 0
				// 		innerRadius: Config.layout.rectangle.radius
				// 		fg: Config.colors.rectangle.bg
				// 		animationDuration: CPUInfo.interval
				// 		anchors.fill: parent
				// 		fraction: value
				// 	}
				// }
			}
		}
	}

	PanelWindow {
		screen: Config.screens.primary
		anchors.left: true; anchors.right: true; anchors.top: true; anchors.bottom: true
		color: "transparent"
		WlrLayershell.layer: WlrLayer.Bottom

		Cava { id: cava; count: 48 }

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

		InwardsRadialVisualizerBars {
			id: cpuViz
			input: CPUInfo
			innerRadius: 120; outerRadius: 220
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.verticalCenter: parent.verticalCenter
			animationDuration: 1000; animationVelocity: 0.0001
			rotationOffset: cpuVizAnim.value

			MomentumAnimation {
				id: cpuVizAnim
				property real t: 0
				property int curveLength: Config.frameRate * 1
				property real speedFromCpuUsage: (1 - CPUInfo.idleSec / CPUInfo.totalSec) / 0.1
				property list<real> opacityCurve: Array.from({ length: curveLength }, (_, i) => 0.8 + 0.2 * Math.sin(i * 2 * Math.PI / curveLength))
				property list<real> curve: Array.from({ length: curveLength }, (_, i) => -1 -.5 * Math.sin(i * 2 * Math.PI / curveLength))
				processValue: (x, frameTime) => {
					const frameDelta = frameTime * Config.frameRate
					t = (t + frameDelta) % curveLength
					const frac = t % 1
					cpuViz.opacity = opacityCurve[Math.floor(t)] * frac + opacityCurve[Math.ceil(t) % curveLength] * (1 - frac)
					return (x + 360 + (curve[Math.floor(t)] * frac + curve[Math.ceil(t) % curveLength] * (1 - frac)) - speedFromCpuUsage * frameDelta) % 360
				}
			}

			MouseArea {
				id: cpuVizMouseArea
				x: cpuViz.width / 2 - cpuViz.outerRadius
				y: cpuViz.height / 2 - cpuViz.outerRadius
				width: cpuViz.outerRadius * 2
				height: cpuViz.outerRadius * 2
				property real startAngle: 0
				property real prevAngle: 0
				property real endAngle: 0
				onPressed: { updateAngle(true); cpuVizAnim.velocity = 0 }
				onReleased: {
					if (endAngle - startAngle > 180) startAngle += 360
					else if (startAngle - endAngle > 180) startAngle -= 360
					cpuVizAnim.impulse(endAngle - startAngle)
				}
				onPositionChanged: updateAngle()

				FrameAnimation { running: true; onTriggered: cpuVizMouseArea.startAngle = cpuVizMouseArea.endAngle }

				function updateAngle(initial) {
					const x = mouseX - cpuViz.outerRadius
					const y = mouseY - cpuViz.outerRadius
					endAngle = Math.atan2(-y, x) * 180 / Math.PI - 90
					if (initial) {
						startAngle = endAngle
						prevAngle = endAngle
					} else {
						cpuVizAnim.value += endAngle - prevAngle
						prevAngle = endAngle
					}
				}

				WheelHandler {
					acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
					onWheel: event => {
						cpuVizAnim.impulse((event.angleDelta.x + event.angleDelta.y) / 4)
					}
				}
			}
		}

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
			anchors.topMargin: (parent.height - Config.layout.hBar.height - height) / 2
		}

		ScrollSpinner {
			anchors.right: parent.right; anchors.top: parent.top
			anchors.rightMargin: 32
			anchors.topMargin: (parent.height - Config.layout.hBar.height - height) / 2
		}

		InteractiveCrewmate {
			color: "transparent"
			maxClickCount: 2
			opacity: 0.4
			anchors.left: parent.left
			anchors.leftMargin: 128
			anchors.top: parent.top
			anchors.topMargin: 64
		}

		BouncingMaskedShaderWidget {
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
