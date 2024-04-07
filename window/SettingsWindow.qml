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
					model: metadata.tabs

					HoverItem {
						Layout.alignment: Qt.AlignRight
						required property string modelData
						inner: settingsTabInner
						onClicked: {
							root.tab = modelData
							console.log("...", metadata.tabInfos, metadata)
							settingsTab.item.modelData = metadata.tabInfos[root.tab]
						}

						Text2 {
							id: settingsTabInner
							text: modelData
						}
					}
				}
			}

			Loader {
				id: settingsTab
				Layout.alignment: Qt.AlignTop
				Layout.fillWidth: true
				sourceComponent: SettingsDynamicItem.component
				onLoaded: item.modelData = metadata.tabInfos[root.tab]
			}
		}
	}

	Item {
		id: metadata
		readonly property list<string> tabs: Object.keys(tabInfos)
		function getSet(path, default_) {
			let parent = config
			const keys = path.split(".")
			for (const key of keys.slice(-1)) {
				parent = parent[key] = parent[key] ?? {}
			}
			const lastKey = keys[keys.length - 1]
			return {
				get: () => parent[lastKey] ?? default_,
				set: v => parent[lastKey] = v,
			}
		}
		function orObj(obj, k) { return obj[k] = obj[k] ?? {} }
		readonly property var tabInfos: {
			"General": ["Tab", {
				"Name": ["TextInput", getSet("name", "you")],
				// TODO: tooltips
				/*
				"Audio service": ["Dropdown", ["None", null], ["WirePlumber", "WirePlumber"], ["PulseAudio", "PulseAudio"]]
				"Network service": ["Dropdown", ["None", null], ["NetworkManager", "NetworkManager"], ["Connman", "Connman"]]
				*/
			}],
			"Theme": ["Tab", {
				"Base text color": ["ColorInput", getSet("theme.base.fg", "black")],
				"Base background color": ["ColorInput", getSet("theme.base.bg", "white")],
				"Corner radius (px)": ["NumberInput", getSet("theme.base.radius", 0)],
				"Margins (px)": ["NumberInput", getSet("theme.base.margins", 0)],
			}],
			"Layout": ["Tab", {
				//
			}],
		}
	}
}
