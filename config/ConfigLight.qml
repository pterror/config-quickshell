import QtQuick
import Quickshell
import "../io"

Singleton {
	id: root
	required property string name
	property bool debug: false
	property QtObject debugFlags: QtObject {
		property bool debugRectangles: root.debug && true
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
			property string accent: root.colors.accent.fg
			property string hoverBg: "#60080f0f"
			property string outline: "#000f0f0f"
		}

		property QtObject button: QtObject {
			property string fg: root.colors.widget.fg
			property string bg: "#00080f0f"
			property string accent: root.colors.accent.fg
			property string hoverBg: root.colors.widget.hoverBg
			property string outline: root.colors.widget.outline
		}

		property QtObject window: QtObject {
			property string fg: root.colors.widget.fg
			property string bg: "#20080f0f"
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
			property string fg: "#40080f0f"
			property string bg: root.colors.panel.bg
			property string outline: root.colors.panel.outline
		}

		property QtObject activateLinux: QtObject {
			property string fg: "#40080f0f"
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
