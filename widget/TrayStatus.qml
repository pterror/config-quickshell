import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import "root:/"
import "root:/component"

RowLayout2 {
	id: root
	Layout.fillHeight: true
	property var menuAlignment: Qt.AlignHCenter | Qt.AlignBottom
	property var edges: Edges.Bottom | Edges.Left
	property var gravity: Edges.Bottom
	implicitWidth: 16 * SystemTray.items.values.length + 8

	Repeater {
		model: SystemTray.items.values

		HoverIcon {
			required property var modelData
			source: modelData.icon
			size: 16
			onClicked: {
				if (!menu.visible) menu.open();
				else menu.close();
			}

			QsMenuAnchor {
				id: menu
				anchor.item: parent
				anchor.edges: root.edges
				anchor.gravity: root.gravity
				anchor.margins.left: anchor.gravity & Edges.Left ? -Config._.style.popup.gap : anchor.gravity & Edges.Right ? 0 : parent.implicitWidth / 2
				anchor.margins.right: anchor.gravity & Edges.Right ? -Config._.style.popup.gap : 0
				anchor.margins.top: anchor.gravity & Edges.Top ? -Config._.style.popup.gap : anchor.gravity & Edges.Top ? 0 : parent.implicitHeight / 2
				anchor.margins.bottom: anchor.gravity & Edges.Bottom ? -Config._.style.popup.gap : 0
				anchor.rect.width: parent.implicitWidth
				anchor.rect.height: parent.implicitHeight

				menu: modelData.menu
			}
		}
	}
}
