import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import qs
import qs.component
import qs.io
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

            Text {
                text: modelData.name
                color: Config._.style.greeter.fg
            }
            Text {
                text: Config._.formatTime(Time.time)
                color: Config._.style.greeter.fg
            }
            Text {
                text: Config._.formatDate(Time.time)
                color: Config._.style.greeter.fg
            }
        }
    }
}