import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray
import qs.component

GridLayout {
	id: root

    Repeater {
        model: SystemTray.items

        HoverIcon {
            required property var modelData
            source: modelData.icon
            size: 16
        }
    }
}
