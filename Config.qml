pragma Singleton

import QtQuick
import Quickshell
import "./input"

Singleton {
	readonly property bool debug: false
	readonly property QtObject debugFlags: QtObject {
		readonly property bool debugRectangles: Config.debug && true
	}

	readonly property var audioProvider: WirePlumber

	readonly property QtObject network: QtObject {
		readonly property string interface_: "wlp10s0" // enp11s0, wlan0, eth0
	}

	readonly property QtObject wallpapers: QtObject {
		readonly property string folder: Quickshell.env("HOME") + "/.config/wallpapers/"
		readonly property list<string> formats: ["*.png"]
		function getSeed() {
			// NOTE: The following line makes wallpaper selection essentially random:
			// return new Date()
			return Math.floor((Number(new Date()) - 7.5 * _HOUR_MS - new Date().getTimezoneOffset() * _MIN_MS) / _DAY_MS)
		}
	}

	readonly property font font: Qt.font({
		family: "Unicorn Scribbles"
	})

	readonly property QtObject layout: QtObject {
		// fallback values for arbitrary rectangles
		readonly property QtObject rectangle: QtObject {
			readonly property int radius: 4
		}

		readonly property QtObject popup: QtObject {
			readonly property int gap: 8
		}

		readonly property QtObject icon: QtObject {
			readonly property int size: 32
		}

		readonly property QtObject widget: QtObject {
			readonly property int radius: 8
			readonly property int margins: 4
			readonly property int border: 0
			readonly property int fontSize: 11
		}

		readonly property QtObject button: QtObject {
			readonly property int radius: 8
			readonly property int margins: 4
			readonly property int border: 0
			readonly property int fontSize: 11
		}

		readonly property QtObject iconButton: QtObject {
			readonly property int size: 32
		}

		readonly property QtObject panel: QtObject {
			readonly property int radius: Config.layout.widget.radius * 2
			readonly property int margins: Config.layout.widget.margins * 2
			readonly property int innerRadius: Config.layout.panel.radius - Config.layout.panel.margins
		}

		readonly property QtObject hBar: QtObject {
			readonly property int radius: Config.layout.widget.radius
			readonly property int margins: Config.layout.widget.margins
			readonly property int border: Config.layout.widget.border
			// NOTE: Currently unused
			readonly property int fontSize: Config.layout.widget.fontSize
			readonly property int height: 32
		}

		readonly property QtObject barItem: QtObject {
			readonly property int radius: 4
			readonly property int margins: Config.layout.button.margins
		}

		readonly property QtObject selection: QtObject {
			readonly property int radius: Config.layout.widget.radius
			readonly property int border: Config.layout.widget.border
		}

		readonly property QtObject mediaPlayer: QtObject {
			readonly property int imageSize: 256
			readonly property int controlsGap: 16
			readonly property int controlGap: 8
		}

		readonly property QtObject audioVisualizer: QtObject {
			readonly property int gap: 4
		}
	}

	readonly property QtObject colors: QtObject {
		// fallback values for arbitrary rectangles
		readonly property QtObject rectangle: QtObject {
			readonly property string bg: "#30ffeef8"
		}

		readonly property QtObject accent: QtObject {
			readonly property string fg: "#ffffaaaa"
		}

		readonly property QtObject bar: QtObject {
			readonly property string bg: "#00e0ffff"
			readonly property string outline: "#00ffffff"
		}

		readonly property QtObject barItem: QtObject {
			readonly property string bg: "#00e0ffff"
			readonly property string hoverBg: "#20e0ffff"
			readonly property string outline: "#00ffffff"
		}

		readonly property QtObject widget: QtObject {
			readonly property string fg: "#a0ffffff"
			readonly property string bg: "#40e0ffff"
			readonly property string accent: Config.colors.accent.fg
			readonly property string hoverBg: "#60e0ffff"
			readonly property string outline: "#00ffffff"
		}

		readonly property QtObject button: QtObject {
			readonly property string fg: "#a0ffffff"
			readonly property string bg: "#00e0ffff"
			readonly property string accent: Config.colors.accent.fg
			readonly property string hoverBg: "#60e0ffff"
			readonly property string outline: "#00ffffff"
		}

		readonly property QtObject panel: QtObject {
			readonly property string fg: Config.colors.widget.fg
			// readonly property string bg: Config.colors.widget.bg
			readonly property string bg: "#20e0ffff"
			readonly property string accent: Config.colors.widget.accent
			readonly property string hoverBg: Config.colors.widget.hoverBg
			readonly property string outline: Config.colors.widget.outline
		}

		readonly property QtObject selection: QtObject {
			readonly property string bg: "#66001017"
			readonly property string outline: "#ee33ccff"
			readonly property string outlineInvalid: "#aa595959"
		}

		readonly property QtObject workspaceIndicator: QtObject {
			readonly property string focused: Config.colors.accent.fg
			readonly property string visible: "#80ffffff"
			readonly property string empty: "#20ffffff"
		}
	}

	readonly property EasingCurve popoutXCurve: EasingCurve {
		curve.type: Easing.OutQuint
	}

	readonly property EasingCurve popoutYCurve: EasingCurve {
		curve.type: Easing.InQuart
	}

	readonly property real _MIN_MS: 60000
	readonly property real _HOUR_MS: 3600000
	readonly property real _DAY_MS: 86400000
}
