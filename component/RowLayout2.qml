import QtQuick
import QtQuick.Layouts
import qs

Rectangle {
	property bool autoSize: false
	color: Config._.debugFlags.debugRectangles ? "#20ff0000" : "transparent"
	border.color: Config._.debugFlags.debugRectangles ? "#80ff0000" : "transparent"
	border.width: Config._.debugFlags.debugRectangles ? 1 : 0
	implicitWidth: autoSize ? container.implicitWidth + container.anchors.margins * 2 : 0
	implicitHeight: autoSize ? container.implicitHeight + container.anchors.margins * 2 : 0
	default property alias content: container.children
	property alias spacing: container.spacing
	property alias margins: container.anchors.margins

	RowLayout {
		id: container
		anchors.fill: parent
	}
}
