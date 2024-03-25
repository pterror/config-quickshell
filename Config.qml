pragma Singleton

import QtQuick
import Quickshell

Singleton {
	readonly property bool debug: false
	readonly property QtObject debugFlags: QtObject {
		readonly property bool debugRectangles: Config.debug && true
	}

	readonly property QtObject wallpapers: QtObject {
		readonly property string folder: Quickshell.env("HOME") + "/.config/wallpapers/"
		readonly property list<string> formats: ["*.png"]
		function getSeed() {
			// NOTE: The following line makes wallpaper selection essentially random:
			// return new Date()
			return Math.floor(Number(new Date()) / 86400000 - (7.5 * 3600000) - new Date().getTimezoneOffset() * 3600000)
		}
	}

	readonly property font font: Qt.font({
		family: "Unicorn Scribbles"
	})

	readonly property QtObject layout: QtObject {
		readonly property QtObject widget: QtObject {
			readonly property int radius: 8
			readonly property int margins: 4
			readonly property int border: 0
			readonly property int fontSize: 11
		}

		readonly property QtObject bar: QtObject {
			readonly property int radius: Config.layout.widget.radius
			readonly property int margins: Config.layout.widget.margins
			readonly property int border: Config.layout.widget.border
			// NOTE: Currently unused
			readonly property int fontSize: Config.layout.widget.fontSize
		}

		readonly property QtObject topBar: QtObject {
			readonly property int radius: Config.layout.bar.radius
			readonly property int border: Config.layout.bar.border
			readonly property int margins: Config.layout.bar.margins
			// NOTE: Currently unused
			readonly property int fontSize: Config.layout.bar.fontSize
			readonly property int height: 32
		}

		readonly property QtObject selection: QtObject {
			readonly property int radius: Config.layout.widget.radius
			readonly property int border: Config.layout.widget.border
		}
	}

	readonly property QtObject colors: QtObject {
		readonly property QtObject accent: QtObject {
			readonly property string fg: "#ffffaaaa"
		}

		readonly property QtObject bar: QtObject {
			readonly property string bg: "#00e0ffff"
			readonly property string outline: "#00ffffff"
		}

		readonly property QtObject widget: QtObject {
			readonly property string fg: "#a0ffffff"
			readonly property string bg: "#00e0ffff"
			readonly property string hoverBg: "#40e0ffff"
			readonly property string outline: "#00ffffff"
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
}
