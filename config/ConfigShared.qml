import QtQuick
import Quickshell
import "../io"
import "../library"

Singleton {
	id: root
	required property string name
	required property url baseUrl
	property int frameRate: 60
	property string terminal: "alacritty"

	function url(path, prefix = "") {
		// this MUST be `==` as a `url`` is not a `string``
		return /^file:|^[/]/.test(path) ? path : baseUrl == "" ? "" : baseUrl + prefix + path
	}

	function imageUrl(path) { return url(path, "image/") }
	function soundUrl(path) { return url(path, "sound/") }
	function videoUrl(path) { return url(path, "video/") }

	property bool debug: false
	property QtObject debugFlags: QtObject {
		property bool debugRectangles: root.debug && true
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

		property QtObject audioVisualizer: QtObject {
			property int gap: 4
		}
	}

	property real iconOpacity: 0xa0 / 0xff

	property QtObject colors: QtObject {
		property string backgroundBlend: "#00000000"
		property QtObject textSelection: QtObject {
			property string bg: "#20e0ffff"
		}

		// fallback values for arbitrary rectangles
		property QtObject rectangle: QtObject {
			property string bg: "#30ffeef8"
		}

		property QtObject accent: QtObject {
			property string fg: "#a0ffaaaa"
		}

		property QtObject bar: QtObject {
			property string bg: "#00e0ffff"
			property string outline: "#00ffffff"
		}

		property QtObject barItem: QtObject {
			property string bg: "#00e0ffff"
			property string hoverBg: "#20e0ffff"
			property string outline: "#00ffffff"
		}

		property QtObject widget: QtObject {
			property string fg: "#a0ffffff"
			property string bg: "#40e0ffff"
			property string accent: root.colors.accent.fg
			property string hoverBg: "#60e0ffff"
			property string outline: "#00ffffff"
		}

		property QtObject button: QtObject {
			property string fg: root.colors.widget.fg
			property string bg: "#00e0ffff"
			property string accent: root.colors.accent.fg
			property string hoverBg: root.colors.widget.hoverBg
			property string outline: root.colors.widget.outline
		}

		property QtObject window: QtObject {
			property string fg: root.colors.widget.fg
			property string bg: "#20e0ffff"
			property string accent: root.colors.widget.accent
			property string hoverBg: root.colors.widget.hoverBg
			property string outline: root.colors.widget.outline
		}

		property QtObject panel: QtObject {
			property string fg: root.colors.window.fg
			property string bg: root.colors.window.bg
			property string accent: root.colors.window.accent
			property string hoverBg: root.colors.window.hoverBg
			property string outline: root.colors.window.outline
		}

		property QtObject greeter: QtObject {
			property string fg: "#40e0ffff"
			property string bg: root.colors.panel.bg
			property string outline: root.colors.panel.outline
		}

		property QtObject activateLinux: QtObject {
			property string fg: "#40e0ffff"
			property string bg: root.colors.panel.bg
			property string outline: root.colors.panel.outline
		}

		property QtObject selection: QtObject {
			property string bg: "#66001017"
			property string outline: "#ee33ccff"
			property string outlineInvalid: "#aa595959"
		}

		property QtObject workspaceIndicator: QtObject {
			property string focused: root.colors.accent.fg
			property string visible: "#80ffffff"
			property string empty: "#20ffffff"
		}

		property QtObject audioVisualizer: QtObject {
			property string barsBg: "#30ffeef8"
		}
	}
}
