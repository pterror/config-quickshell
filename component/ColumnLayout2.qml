import QtQuick
import QtQuick.Layouts
import ".."

Rectangle {
	default property alias content: container.children
	property bool autoSize: false
	property alias spacing: container.spacing
	property alias margins: container.anchors.margins
	color: Config.debugFlags.debugRectangles ? "#20ff0000" : "transparent"
	border.color: Config.debugFlags.debugRectangles ? "#80ff0000" : "transparent"
	border.width: Config.debugFlags.debugRectangles ? 1 : 0
	implicitWidth: autoSize ? container.implicitWidth + container.anchors.margins * 2 : 0
	implicitHeight: autoSize ? container.implicitHeight + container.anchors.margins * 2 : 0

	ColumnLayout {
		id: container
		anchors.fill: parent
	}
}
