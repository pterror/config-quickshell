import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import "root:/component"
import "root:/library"
import "root:/"
import "root:/library/temporal.mjs" as Temporal

ColumnLayout {
	FileView {
        id: timezonesToDisplayFile
        path: Qt.resolvedUrl("../timezonesToDisplay.json")
        blockLoading: true
    }

    Repeater {
        property date foo: new Date()
        model: JSON.parse(timezonesToDisplayFile.text())

        RowLayout {
            required property var modelData
            property var localizedTime: console.log(Temporal) || Time.time

            Text2 {
                text: modelData.name
                color: Config.colors.greeter.fg
            }
            Text2 {
                text: Config.formatTime(Time.time)
                color: Config.colors.greeter.fg
            }
            Text2 {
                text: Config.formatDate(Time.time)
                color: Config.colors.greeter.fg
            }
        }
    }
}