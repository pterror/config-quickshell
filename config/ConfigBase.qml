import QtQuick
import QtQuick.Controls
import Quickshell
import "../io"
import "../library"

Singleton {
	id: root
	required property string name
	required property url baseUrl
	property int frameRate: 60
	property string terminal: Quickshell.env("TERM") ?? "gnome-terminal"
	property string shell: Quickshell.env("SHELL") ?? "bash"

	property QtObject screens: QtObject {
		property ShellScreen primary: Quickshell.screens[0]
	}

	function url(path, prefix = "") { return Qt.resolvedUrl("../" + prefix + path) }
	function iconUrl(path) { return url(path, "icon/") }
	function imageUrl(path) { return url(path, "image/") }
	function soundUrl(path) { return url(path, "sound/") }
	function videoUrl(path) { return url(path, "video/") }

	function getScreen(name) {
		return Quickshell.screens.find(screen => screen.name === name) ??
			Quickshell.screens.find(screen => screen.name.startsWith(name)) ??
			Quickshell.screens.find(screen => screen.name.includes(name)) ??
			Quickshell.screens[0]
	}

	property bool debug: false
	property QtObject debugFlags: QtObject {
		property bool debugRectangles: root.debug && true
	}

	property QtObject tooltip: QtObject {
		property int delay: 1000
		property int timeout: 5000
	}

	Item {
		ToolTip.toolTip.contentItem: Text {
			color: root.colors.tooltip.fg
			text: ToolTip.toolTip.text
		}
		ToolTip.toolTip.background: Rectangle {
			color: root.colors.tooltip.bg
			border.color: root.colors.tooltip.outline
		}
	}

	property QtObject activateLinux: QtObject {
		property string name: "NixOS"
	}

	property QtObject services: QtObject {
		property var audio: WirePlumber
		property var network: NetworkManager
	}

	property QtObject network: QtObject {
		property string interface_: "wlp10s0" // enp11s0, wlan0, eth0
	}

	property real _MIN_MS: 60000
	property real _HOUR_MS: 3600000
	property real _DAY_MS: 86400000

	property QtObject wallpapers: QtObject {
		property string folder: Quickshell.env("HOME") + "/.config/wallpapers/"
		property list<string> formats: ["*"]
		property real seed: Math.floor((Number(Time.time) - 7.5 * _HOUR_MS - Time.time.getTimezoneOffset() * _MIN_MS) / _DAY_MS)
	}

	property font font: Qt.font({
		family: "Unicorn Scribbles"
	})

	property QtObject shaderWallpaper: QtObject {
		property string shader: "Night_Sky"
		property real speed: 1.0
		property bool mouse: true
		property real mouseSpeedBias: 1.0
		property string channel0: imageUrl("blank.png")
		property string channel1: imageUrl("blank.png")
		property string channel2: imageUrl("blank.png")
		property string channel3: imageUrl("blank.png")
	}

	property QtObject workspacesOverview: QtObject {
		property bool visible: false
	}

	property QtObject wLogout: QtObject {
		property bool visible: false
	}

	property QtObject crankableImage: QtObject {
		property real opacity: 0.25
	}

	property QtObject bouncingMaskedShader: QtObject {
		property real opacity: 0.3
		property real speed: 1.0
		property bool mouse: false
		property real mouseSpeedBias: 1.0
		property real velocityX: 256.0
		property real velocityY: 192.0
		property string shader: "full_spectrum_cyber_masked"
		property string mask: imageUrl("dvd_logo.svg")
		property int maskWidth: 320
		property int maskHeight: -1
		property string channel0: imageUrl("blank.png")
		property string channel1: imageUrl("blank.png")
		property string channel2: imageUrl("blank.png")
		property string channel3: imageUrl("blank.png")
	}

	property QtObject layout: QtObject {
		// fallback values for arbitrary rectangles
		property QtObject rectangle: QtObject {
			property int radius: 4
		}

		property QtObject popup: QtObject {
			property int gap: 8
		}

		property QtObject icon: QtObject {
			property int size: 32
		}

		property QtObject widget: QtObject {
			property int radius: 8
			property int margins: 4
			property int border: 0
			property int fontSize: 11
		}

		property QtObject window: QtObject {
			property int radius: 8
			property int margins: 4
			property int border: 0
			property int fontSize: 11
		}

		property QtObject button: QtObject {
			property int radius: 8
			property int margins: 4
			property int border: 0
			property int fontSize: 11
		}

		property QtObject iconButton: QtObject {
			property int size: 32
		}

		property QtObject panel: QtObject {
			property int radius: root.layout.widget.radius * 2
			property int margins: root.layout.widget.margins * 2
			property int innerRadius: root.layout.panel.radius - root.layout.panel.margins
		}

		property QtObject hBar: QtObject {
			property int radius: root.layout.widget.radius
			property int margins: root.layout.widget.margins
			property int border: root.layout.widget.border
			// NOTE: Currently unused
			property int fontSize: root.layout.widget.fontSize
			property int height: 32
		}

		property QtObject barItem: QtObject {
			property int radius: 4
			property int margins: root.layout.button.margins
		}

		property QtObject selection: QtObject {
			property int radius: root.layout.widget.radius
			property int border: root.layout.widget.border
		}

		property QtObject mediaPlayer: QtObject {
			property int imageSize: 256
			property int controlsGap: 16
			property int controlGap: 8
		}

		property QtObject visualizer: QtObject {
			property int gap: 4
		}
	}

	property real iconOpacity: 0xa0 / 0xff

	property QtObject colors: QtObject {
		property color backgroundBlend: "#00000000"
		property QtObject textSelection: QtObject {
			property color bg: "#20e0ffff"
		}

		// fallback values for arbitrary rectangles
		property QtObject rectangle: QtObject {
			property color bg: "#30ffeef8"
		}

		property QtObject accent: QtObject {
			property color fg: "#a0ffaaaa"
		}

		property QtObject bar: QtObject {
			property color bg: "#00e0ffff"
			property color outline: "#00ffffff"
		}

		property QtObject barItem: QtObject {
			property color bg: "#00e0ffff"
			property color hoverBg: "#20e0ffff"
			property color outline: "#00ffffff"
		}

		property QtObject widget: QtObject {
			property color fg: "#a0ffffff"
			property color bg: "#40e0ffff"
			property color accent: root.colors.accent.fg
			property color hoverBg: "#60e0ffff"
			property color outline: "#00ffffff"
		}

		property QtObject button: QtObject {
			property color fg: root.colors.widget.fg
			property color bg: "#00e0ffff"
			property color accent: root.colors.accent.fg
			property color hoverBg: root.colors.widget.hoverBg
			property color outline: root.colors.widget.outline
		}

		property QtObject tooltip: QtObject {
			property color fg: root.colors.button.fg
			property color bg: root.colors.button.bg
			property color outline: root.colors.button.outline
		}

		property QtObject window: QtObject {
			property color fg: root.colors.widget.fg
			property color bg: "#20e0ffff"
			property color accent: root.colors.widget.accent
			property color hoverBg: root.colors.widget.hoverBg
			property color outline: root.colors.widget.outline
		}

		property QtObject panel: QtObject {
			property color fg: root.colors.window.fg
			property color bg: root.colors.window.bg
			property color accent: root.colors.window.accent
			property color hoverBg: root.colors.window.hoverBg
			property color outline: root.colors.window.outline
		}

		property QtObject greeter: QtObject {
			property color fg: "#40e0ffff"
			property color bg: root.colors.panel.bg
			property color outline: root.colors.panel.outline
		}

		property QtObject activateLinux: QtObject {
			property color fg: "#40e0ffff"
			property color bg: root.colors.panel.bg
			property color outline: root.colors.panel.outline
		}

		property QtObject selection: QtObject {
			property color bg: "#66001017"
			property color outline: "#ee33ccff"
			property color outlineInvalid: "#aa595959"
		}

		property QtObject workspacesOverview: QtObject {
			property color fg: root.colors.panel.fg
			property color bg: "transparent" // root.colors.panel.bg
			property color accent: root.colors.panel.accent
			property color hoverBg: root.colors.panel.hoverBg
			property color outline: root.colors.panel.outline
		}

		property QtObject workspaceIndicator: QtObject {
			property color focused: root.colors.accent.fg
			property color visible: "#80ffffff"
			property color empty: "#20ffffff"
		}

		property QtObject visualizer: QtObject {
			property color barsBg: "#30ffeef8"
		}

		property QtObject wLogout: QtObject {
			property color bg: "#e60c0c0c"
			property color buttonBg: "#1e1e1e"
			property color buttonHoverBg: "#3700b3"
		}
	}
}
