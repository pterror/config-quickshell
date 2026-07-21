import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import Qt.labs.folderlistmodel
import qs.io
import qs.component
import qs

// Hosts desktop-gadget-style widgets, dynamically discovered from `widgetsFolder`.
// Toggle with `Config._.widgets.visible` (bar button / keybind). `Config._.widgets.mode`
// picks between an overlay layer (click-outside-to-dismiss, via HyprlandFocusGrab) and a
// background layer (always visible, no dismiss behavior, like desktop icons).
LazyLoader {
	id: root
	property list<var> extraGrabWindows: []
	property url widgetsFolder: Config.url("", "widget/dashboard/")

	readonly property bool isBackground: Config._.widgets.mode === "background"
	property bool shouldShow: isBackground || Config._.widgets.visible
	onShouldShowChanged: {
		if (shouldShow) loading = true
		else active = false
	}
	// `onShouldShowChanged` only fires on change, not on the initial binding, so a config
	// that starts in background mode (or already visible) still needs an explicit kick.
	Component.onCompleted: if (shouldShow) loading = true

	FolderListModel {
		id: widgetFiles
		folder: root.widgetsFolder
		nameFilters: ["*.qml"]
		showDirs: false
		showOnlyReadable: true
	}

	PanelWindow {
		id: window
		screen: Config.services.compositor.focusedScreen ?? Config.screens.primary
		color: "transparent"
		WlrLayershell.namespace: "shell:widgets"
		WlrLayershell.layer: root.isBackground ? WlrLayer.Background : WlrLayer.Overlay
		exclusionMode: ExclusionMode.Ignore
		anchors { top: true; bottom: true; left: true; right: true }

		visible: root.isBackground || Config._.widgets.visible

		onVisibleChanged: {
			if (root.isBackground || !visible) return
			grab.active = true
		}

		HyprlandFocusGrab {
			id: grab
			// no grab windows in background mode: nothing to dismiss, it just sits there
			windows: root.isBackground ? [] : [window].concat(extraGrabWindows)
			active: false
			onActiveChanged: {
				if (root.isBackground) return
				Config._.widgets.visible = active
			}
		}

		Item {
			id: canvas
			anchors.fill: parent

			Repeater {
				model: widgetFiles

				Loader {
					id: widgetLoader
					required property string fileBaseName
					required property string filePath
					required property int index
					source: "file://" + filePath
					active: Config._.widgets.enabled[fileBaseName] !== false
					onLoaded: {
						item.widgetId = fileBaseName
						item.index = index
					}
				}
			}
		}
	}
}
