import QtQuick
import Quickshell.Services.SystemTray
import "root:/component"

RowLayout2 {
	id: root

    Repeater {
        model: SystemTray.items

        Rectangle {
            required property var modelData
            property var foo: console.log(Object.keys(modelData))
        }
    }
}