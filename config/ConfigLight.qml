import QtQuick
import Quickshell
import "root:/io"

ConfigBase {
	id: root
	wallpapers.folder: Quickshell.env("HOME") + "/.config/wallpapers/light/"

	property QtObject colors: QtObject {
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

		property QtObject tooltip: QtObject {
			property color fg: root.colors.button.fg
			property color bg: root.colors.button.bg
			property color outline: root.colors.button.outline
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

		property QtObject workspacesOverview: QtObject {
			property color fg: root.colors.panel.fg
			property color bg: "transparent" // root.colors.panel.bg
			property color accent: root.colors.panel.accent
			property color hoverBg: root.colors.panel.hoverBg
			property color outline: root.colors.panel.outline
		}

		property QtObject workspaceIndicator: QtObject {
			property string focused: root.colors.accent.fg
			property string visible: "#800f0f0f"
			property string empty: "#200f0f0f"
		}

		property QtObject visualizer: QtObject {
			property string barsBg: "#300f0e0f"
		}

		property QtObject wLogout: QtObject {
			property color bg: "#e60c0c0c"
			property color buttonBg: "#1e1e1e"
			property color buttonHoverBg: "#3700b3"
		}
	}
}
