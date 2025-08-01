import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris
import Quickshell.Services.Pipewire
import qs.io

Singleton {
	property JsonAdapter _: root

	property real _MIN_MS: 60000
	property real _HOUR_MS: 3600000
	property real _DAY_MS: 86400000

	function writeConfig() {
		file.writeAdapter()
	}

	property QtObject screens: QtObject {
		property ShellScreen primary: getScreen(root.screens.primary) ?? Quickshell.screens[0]
	}

	property QtObject mpris: QtObject {
		property MprisPlayer currentPlayer: Mpris.players.values[0] ?? null
	}

	property QtObject wallpapers: QtObject {
		property Component effect: MultiEffect { colorization: 0.85; colorizationColor: Qt.rgba(0.05, 0.05, 0.05, 1.0) }
	}

	property font font: Qt.font({ family: root.font.family })

	Variants {
		model: Mpris.players.values
		Connections {
			property MprisPlayer modelData
			target: modelData
			function onTrackChanged() { root.mpris.currentPlayer = modelData }
		}
	}

	Item {
		ToolTip.toolTip.contentItem: Text {
			color: root.style.tooltip.fg
			text: ToolTip.toolTip.text
		}
		ToolTip.toolTip.background: Rectangle {
			color: root.style.tooltip.bg
			border.color: root.style.tooltip.outline
		}
	}

	PwObjectTracker {
		objects: [Pipewire.defaultAudioSink, Pipewire.defaultAudioSource]
	}

	function isSpecialWorkspace(name: string): bool {
		return /^special:/i.test(name);
	}

	function formatDateTime(date: date, format = Locale.LongFormat): string {
		return date.toLocaleString(root.dateLocale, format)
	}

	function formatDate(date: date, format = Locale.LongFormat): string {
		return date.toLocaleDateString(root.dateLocale, format)
	}

	function formatTime(date: date, format = Locale.LongFormat): string {
		return date.toLocaleTimeString(root.dateLocale, format)
	}

	function withBgOpacity(color: string): string {
		return color.replace("#", "#" + (0 | _.backgroundOpacity * 255).toString(16).padStart(2, "0"))
	}

	function url(path: string, prefix = ""): url { return Qt.resolvedUrl("../" + prefix + path) }
	function iconUrl(path: string): url { return url(path, "icon/") }
	function imageUrl(path: string): url { return url(path, "image/") }
	function soundUrl(path: string): url { return url(path, "sound/") }
	function videoUrl(path: string): url { return url(path, "video/") }

	function getScreen(name: string): ShellScreen {
		return Quickshell.screens.find(screen => screen.name === name) ??
			Quickshell.screens.find(screen => screen.name.startsWith(name)) ??
			Quickshell.screens.find(screen => screen.name.includes(name)) ??
			Quickshell.screens[0]
	}

	property QtObject services: QtObject {
		property var audio: QtObject {
			property bool initialized: volume === volume && micVolume === micVolume // check for NaNs
			// cannot be `string` as they are initially `undefined`
			property var name: Pipewire.defaultAudioSink?.nickname
			property var micName: Pipewire.defaultAudioSource?.nickname
			property real volume: Pipewire.defaultAudioSink?.audio?.volume ?? 0
			property real micVolume: Pipewire.defaultAudioSource?.audio?.volume ?? 0
			property bool muted: Pipewire.defaultAudioSink?.audio?.muted ?? false
			property bool micMuted: Pipewire.defaultAudioSource?.audio?.muted ?? false

			function setVolume(volume: real) {
				if (!Pipewire.defaultAudioSink?.audio) return
				Pipewire.defaultAudioSink.audio.volume = volume
			}

			function changeVolume(change: real) {
				if (!Pipewire.defaultAudioSink?.audio) return
				Pipewire.defaultAudioSink.audio.volume += change
			}

			function setMicVolume(volume: real) {
				if (!Pipewire.defaultAudioSource?.audio) return
				Pipewire.defaultAudioSource.audio.volume = volume
			}

			function changeMicVolume(change: real) {
				if (!Pipewire.defaultAudioSource?.audio) return
				Pipewire.defaultAudioSource.audio.volume += change
			}

			function setMuted(muted: bool) {
				if (!Pipewire.defaultAudioSink?.audio) return
				Pipewire.defaultAudioSink.audio.muted = muted
			}

			function toggleMute() { setMuted(!muted) }

			function setMicMuted(muted: bool) {
				if (!Pipewire.defaultAudioSource?.audio) return
				Pipewire.defaultAudioSource.audio.muted = muted
			}

			function toggleMicMute() { setMicMuted(!micMuted) }
		}
		property var network: NetworkManager
		property var compositor: Hyprland
	}

	FileView {
		id: file
		path: url("config.json")
		watchChanges: true
		onFileChanged: reload()

		JsonAdapter {
			id: root
			property string name: "you"
			property bool owo: false
			property bool widgetsAcrossAllScreens: false
			property real backgroundOpacity: 0.8
			property bool moreTransparency: false
			property bool reducedMotion: false
			property bool liveWindowPreviews: false
			property bool liveWorkspacePreviews: liveWindowPreviews
			property int workspaceCount: 9
			property url baseUrl: ""
			property int frameRate: 60
			property var locale: undefined
			property var dateLocale: root.locale
			property string terminal: Quickshell.env("TERM") ?? "gnome-terminal"
			property string shell: Quickshell.env("SHELL") ?? "bash"

			property JsonObject screens: JsonObject {
				property string primary: "HDMI-A-1"
			}

			property bool debug: false
			property JsonObject debugFlags: JsonObject {
				property bool debugRectangles: root.debug && true
			}

			property JsonObject activateLinux: JsonObject {
				property string name: (root.owo ? "Linuwux" : "Linux")
			}

			property JsonObject network: JsonObject {
				property string interface_: "wlp10s0" // enp11s0, wlan0, eth0
			}

			property JsonObject wallpapers: JsonObject {
				property string folder: Quickshell.env("HOME") + "/.config/wallpapers/"
				property list<string> formats: ["*"]
				property real seed: Math.floor((Number(Time.time) - 7.5 * _HOUR_MS - Time.time.getTimezoneOffset() * _MIN_MS) / _DAY_MS)
				property JsonObject panorama: JsonObject {
					property real fov: 60
					property real minFov: 10
					property real maxFov: 135
					property real rightClickZoom: 2
					property real fovAnimationDuration: 100
					property real scrollExponent: 1.05
				}
			}

			property JsonObject font: JsonObject {
				property string family: "Noto Sans"
			}

			property JsonObject shaderWallpaper: JsonObject {
				property string shader: "Night_Sky"
				// property string shader: "../shader/full_spectrum_cyber.frag.qsb"
				property real speed: 1.0
				property bool mouse: true
				property real mouseSpeedBias: 1.0
				property string channel0: imageUrl("blank.png")
				property string channel1: imageUrl("blank.png")
				property string channel2: imageUrl("blank.png")
				property string channel3: imageUrl("blank.png")
			}

			property JsonObject workspacesOverview: JsonObject {
				property bool visible: false
			}

			property JsonObject wLogout: JsonObject {
				property bool visible: false
			}

			property JsonObject crankableImage: JsonObject {
				property real opacity: 0.25
			}

			property JsonObject bouncingMaskedShader: JsonObject {
				property real opacity: 0.3
				property real speed: 1.0
				property bool mouse: false
				property real mouseSpeedBias: 1.0
				property real velocityX: 256.0
				property real velocityY: 192.0
				// the cycle length of full_spectrum_cyber is 20
				property real timeMod: 1000.0 // 0.0
				property string shader: "full_spectrum_cyber_masked"
				property string mask: imageUrl("crewmate_transparenter_cropped_negative.png")
				property int maskWidth: -1
				property int maskHeight: 208
				property string channel0: imageUrl("blank.png")
				property string channel1: imageUrl("blank.png")
				property string channel2: imageUrl("blank.png")
				property string channel3: imageUrl("blank.png")
			}

			property JsonObject style: JsonObject {
				property color primaryFg: "#a0e0ffff"
				property color primaryBg: withBgOpacity("#1a1d26")
				property color primaryHoverBg: withBgOpacity("#e0ffff")
				property color secondaryFg: "#40e0ffff"
				property color secondaryBg: withBgOpacity("#272d42")
				property color selectionBg: withBgOpacity("#e0ffff")
				property color accentFg: "#a0ffaaaa"
				property color highlightBg: "#30ffeef8"

				// fallback values for arbitrary rectangles
				property JsonObject rectangle: JsonObject {
					property int radius: 4

					property color bg: root.style.highlightBg
					property color fg: "#00ffeef8"
				}

				property JsonObject textSelection: JsonObject {
					property color bg: root.style.selectionBg
				}

				property JsonObject popup: JsonObject {
					property int gap: 8
				}

				property JsonObject icon: JsonObject {
					property int size: 32
				}

				property JsonObject widget: JsonObject {
					property int radius: 8
					property int margins: 4
					property int border: 0
					property int fontSize: 11

					property color fg: root.style.primaryFg
					property color bg: root.style.secondaryBg
					property color accent: root.style.accentFg
					property color hoverBg: "#38e0ffff"
					property color outline: "#00ffffff"
				}

				property JsonObject button: JsonObject {
					property int radius: 8
					property int margins: 4
					property int border: 0
					property int fontSize: 11

					property color fg: root.style.widget.fg
					property color bg: root.style.primaryBg
					property color accent: root.style.accentFg
					property color hoverBg: root.style.widget.hoverBg
					property color outline: root.style.widget.outline

					property int animationDuration: 150
					
					property real pressedScale: 0.9
					property real pressedScaleSpeed: 2
				}

				property JsonObject tooltip: JsonObject {
					property color fg: root.style.button.fg
					property color bg: root.style.button.bg
					property color outline: root.style.button.outline

					property int delay: 1000
					property int timeout: 5000
				}

				property JsonObject window: JsonObject {
					property int radius: 8
					property int margins: 4
					property int border: 0
					property int fontSize: 11

					property color fg: root.style.widget.fg
					property color bg: root.style.widget.bg
					property color accent: root.style.widget.accent
					property color hoverBg: root.style.widget.hoverBg
					property color outline: root.style.widget.outline
				}

				property JsonObject iconButton: JsonObject {
					property int size: 32
				}

				property JsonObject panel: JsonObject {
					property int radius: root.style.widget.radius * 2
					property int margins: root.style.widget.margins * 2
					property int innerRadius: root.style.panel.radius - root.style.panel.margins

					property color fg: root.style.window.fg
					property color bg: root.style.window.bg
					property color accent: root.style.window.accent
					property color hoverBg: root.style.window.hoverBg
					property color outline: root.style.window.outline
				}

				property JsonObject bar: JsonObject {
					property color bg: root.style.primaryBg
					property color outline: "#00ffffff"
				}

				property JsonObject hBar: JsonObject {
					property int radius: 0 // root.style.widget.radius
					property int margins: root.style.widget.margins
					property int border: root.style.widget.border
					// NOTE: Currently unused
					property int fontSize: 11
					property int height: 32
				}

				property JsonObject barItem: JsonObject {
					property int radius: 4
					property int margins: root.style.button.margins

					property color bg: root.moreTransparency ? "#00000000" : root.style.primaryBg
					property color hoverBg: "#20e0ffff"
					property color outline: "#00ffffff"
				}

				property JsonObject selection: JsonObject {
					property int radius: root.style.widget.radius
					property int border: root.style.widget.border

					property color bg: "#66001017"
					property color outline: "#ee33ccff"
					property color outlineInvalid: "#aa595959"
				}

				property JsonObject mediaPlayer: JsonObject {
					property int imageSize: 256
					property int controlsGap: 16
					property int controlGap: 8
				}

				property JsonObject visualizer: JsonObject {
					property int gap: 4

					property color barsBg: root.style.rectangle.bg
					property color barsFg: root.style.rectangle.fg
				}

				property JsonObject greeter: JsonObject {
					property color fg: root.style.secondaryFg
					property color bg: root.style.panel.bg
					property color outline: root.style.panel.outline
				}

				property JsonObject activateLinux: JsonObject {
					property color fg: root.style.secondaryFg
					property color bg: root.style.panel.bg
					property color outline: root.style.panel.outline
				}

				property JsonObject workspacesOverview: JsonObject {
					property color fg: root.style.panel.fg
					property color bg: "transparent" // root.style.panel.bg
					property color accent: root.style.panel.accent
					property color hoverBg: root.style.panel.hoverBg
					property color outline: root.style.panel.outline
				}

				property JsonObject wLogout: JsonObject {
					property color bg: "#e60c0c0c"
					property color buttonBg: "#1e1e1e"
					property color buttonHoverBg: "#3700b3"
				}

				property JsonObject trayStatus: JsonObject {
					property int iconSize: 16
				}

				property JsonObject network: JsonObject {
					property color uploadFg: "#a088ffaa"
					property color downloadFg: "#a0ff88aa"
				}
			}

			property real iconOpacity: 0xa0 / 0xff
		}
	}
}
