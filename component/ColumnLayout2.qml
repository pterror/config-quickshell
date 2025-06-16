import QtQuick
import QtQuick.Layouts
import "root:/"

Rectangle {
	default property alias content: container.children
	property bool autoSize: false
	property alias spacing: container.spacing
	property alias margins: container.anchors.margins
	color: Config._.debugFlags.debugRectangles ? "#20ff0000" : "transparent"
	border.color: Config._.debugFlags.debugRectangles ? "#80ff0000" : "transparent"
	border.width: Config._.debugFlags.debugRectangles ? 1 : 0
	implicitWidth: autoSize ? container.implicitWidth + container.anchors.margins * 2 : 0
	implicitHeight: autoSize ? container.implicitHeight + container.anchors.margins * 2 : 0

	ColumnLayout {
		id: container
		anchors.fill: parent
	}
}
