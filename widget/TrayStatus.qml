import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import qs
import qs.component

RowLayout {
	id: root
	Layout.fillHeight: true
	property PanelWindow anchorWindow: null
	property Item anchorItem: null
	property list<var> extraGrabWindows: []

	Repeater {
		model: SystemTray.items.values

		HoverIcon {
			id: icon
			required property var modelData
			source: modelData.icon
			size: Config._.style.trayStatus.iconSize
			onClicked: {
				if (!menuLoader.active) menuLoader.loading = true
				else menuLoader.active = false
			}

			LazyLoader {
				id: menuLoader
				PopupWindow {
					id: menuPopup
					anchor.window: root.anchorWindow
					anchor.rect.x: icon.mapToItem(root.anchorItem, icon.width / 2, 0).x - menuPopup.implicitWidth / 2
					anchor.rect.y: icon.mapToItem(root.anchorItem, 0, icon.height).y + Config._.style.popup.gap
					extraGrabWindows: root.extraGrabWindows
					visible: true
					onDismissed: Qt.callLater(() => menuLoader.active = false)
					TrayMenu {
						menu: icon.modelData.menu
						onTriggered: menuLoader.active = false
					}
				}
			}
		}
	}
}
