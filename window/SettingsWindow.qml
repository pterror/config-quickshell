import Quickshell
import QtQuick
import QtQuick.Layouts
import "../component"
import "../widget"
import ".."

FloatingWindow {
	id: root
	width: 800
	height: 600
	color: "transparent"
	property string tab: "Theme"

	// FIXME: temporary
	property var config: ({})

	Rectangle {
		anchors.fill: parent
		color: Config.colors.window.bg
		radius: Config.layout.window.radius

		RowLayout2 {
			anchors.fill: parent
			// TODO: make these configurable
			anchors.margins: 8
			spacing: 16

			ColumnLayout2 {
				autoSize: true
				Layout.alignment: Qt.AlignTop

				Repeater {
					model: data.tabs

					HoverItem {
						Layout.alignment: Qt.AlignRight
						required property string modelData
						inner: settingsTabInner
						onClicked: root.tab = modelData

						Text2 {
							id: settingsTabInner
							text: modelData
						}
					}
				}
			}

			SettingsDynamicItem { modelData: data.tabInfos[root.tab] }
		}
	}

	Item {
		id: data
		readonly property list<string> tabs: Object.keys(tabInfos)
		function orObj(obj, k) { return obj[k] = obj[k] ?? {} }
		readonly property var tabInfos: {
			"Theme": ["Tab", {
				"Base text color": ["ColorInput", () => config?.theme?.base?.fg ?? "black", v => orObj(orObj(config, "theme"), "base").fg = v],
				"Base background color": ["ColorInput", () => config?.theme?.base?.bg ?? "white", v => orObj(orObj(config, "theme"), "base").bg = v],
				"Corner radius (px)": ["NumberInput", () => config?.theme?.base?.radius ?? 0, v => orObj(orObj(config, "theme"), "base").radius = v],
				"Margins (px)": ["NumberInput", () => config?.theme?.base?.margins ?? 0, v => orObj(orObj(config, "theme"), "base").margins = v],
			}],
			"Layout": ["Tab", {
				//
			}],
		}
	}
}
