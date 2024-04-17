pragma Singleton

import QtQuick
import Quickshell
import "./io"

Singleton {
	property string name: "n_n"
	property bool debug: false
	property QtObject debugFlags: QtObject {
		property bool debugRectangles: Config.debug && true
	}

	property QtObject activateLinux: QtObject {
		property string name: "NixOS"
	}

	property QtObject services: QtObject {
		property var audio: WirePlumber
		// property var network: NetworkManager
	}

	property QtObject network: QtObject {
		property string interface_: "wlp10s0" // enp11s0, wlan0, eth0
	}

	property QtObject wallpapers: QtObject {
		property string folder: Quickshell.env("HOME") + "/.config/wallpapers_light/"
		property list<string> formats: ["*"]
		function getSeed() {
			// NOTE: The following line makes wallpaper selection essentially random:
			// return new Date()
			return Math.floor((Number(new Date()) - 7.5 * _HOUR_MS - new Date().getTimezoneOffset() * _MIN_MS) / _DAY_MS)
		}
	}

	property font font: Qt.font({
		family: "Unicorn Scribbles"
	})

	property QtObject shaderWallpaper: QtObject {
		property string shader: "Night_Sky"
		property real speed: 1.0
		property bool mouse: true
		property real mouseSpeedBias: 1.0
		property string channel0: "../blank.png"
		property string channel1: "../blank.png"
		property string channel2: "../blank.png"
		property string channel3: "../blank.png"
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
			property int radius: Config.layout.widget.radius * 2
			property int margins: Config.layout.widget.margins * 2
			property int innerRadius: Config.layout.panel.radius - Config.layout.panel.margins
		}

		property QtObject hBar: QtObject {
			property int radius: Config.layout.widget.radius
			property int margins: Config.layout.widget.margins
			property int border: Config.layout.widget.border
			// NOTE: Currently unused
			property int fontSize: Config.layout.widget.fontSize
			property int height: 32
		}

		property QtObject barItem: QtObject {
			property int radius: 4
			property int margins: Config.layout.button.margins
		}

		property QtObject selection: QtObject {
			property int radius: Config.layout.widget.radius
			property int border: Config.layout.widget.border
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

	property QtObject colors: QtObject {
		property string backgroundBlend: "#20ffffff"
		property QtObject textSelection: QtObject {
			property string bg: "#20080f0f"
		}

		// fallback values for arbitrary rectangles
		property QtObject rectangle: QtObject {
			property string bg: "#30ffeef8"
		}

		property QtObject accent: QtObject {
			property string fg: "#a0ffaaaa"
		}

		property QtObject bar: QtObject {
			property string bg: "#00080f0f"
			property string outline: "#000f0f0f"
		}

		property QtObject barItem: QtObject {
			property string bg: "#00080f0f"
			property string hoverBg: "#20080f0f"
			property string outline: "#000f0f0f"
		}

		property QtObject widget: QtObject {
			property string fg: "#a00f0f0f"
			property string bg: "#40080f0f"
			property string accent: Config.colors.accent.fg
			property string hoverBg: "#60080f0f"
			property string outline: "#000f0f0f"
		}

		property QtObject button: QtObject {
			property string fg: Config.colors.widget.fg
			property string bg: "#00080f0f"
			property string accent: Config.colors.accent.fg
			property string hoverBg: Config.colors.widget.hoverBg
			property string outline: Config.colors.widget.outline
		}

		property QtObject window: QtObject {
			property string fg: Config.colors.widget.fg
			property string bg: "#20080f0f"
			property string accent: Config.colors.widget.accent
			property string hoverBg: Config.colors.widget.hoverBg
			property string outline: Config.colors.widget.outline
		}

		property QtObject panel: QtObject {
			property string fg: Config.colors.window.fg
			property string bg: Config.colors.window.bg
			property string accent: Config.colors.window.accent
			property string hoverBg: Config.colors.window.hoverBg
			property string outline: Config.colors.window.outline
		}

		property QtObject greeter: QtObject {
			property string fg: "#40080f0f"
			property string bg: Config.colors.panel.bg
			property string outline: Config.colors.panel.outline
		}

		property QtObject activateLinux: QtObject {
			property string fg: "#40080f0f"
			property string bg: Config.colors.panel.bg
			property string outline: Config.colors.panel.outline
		}

		property QtObject selection: QtObject {
			property string bg: "#66001017"
			property string outline: "#ee33ccff"
			property string outlineInvalid: "#aa595959"
		}

		property QtObject workspaceIndicator: QtObject {
			property string focused: Config.colors.accent.fg
			property string visible: "#800f0f0f"
			property string empty: "#200f0f0f"
		}

		property QtObject audioVisualizer: QtObject {
			property string barsBg: "#300f0e0f"
		}
	}

	property real _MIN_MS: 60000
	property real _HOUR_MS: 3600000
	property real _DAY_MS: 86400000
}
