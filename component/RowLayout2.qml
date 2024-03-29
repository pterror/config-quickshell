import QtQuick
import QtQuick.Layouts
import ".."

Rectangle {
	property bool autoSize: false
	color: Config.debugFlags.debugRectangles ? "#20ff0000" : "transparent"
	border.color: Config.debugFlags.debugRectangles ? "#80ff0000" : "transparent"
	border.width: Config.debugFlags.debugRectangles ? 1 : 0
	implicitWidth: autoSize ? container.implicitWidth : 0
	implicitHeight: autoSize ? container.implicitHeight : 0
	default property alias content: container.children

	RowLayout {
		id: container
		anchors.fill: parent
	}
}
