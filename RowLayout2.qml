import QtQuick
import QtQuick.Layouts

Rectangle {
	color: Config.debugFlags.debugRectangles ? "#20ff0000" : "transparent"
	border.color: Config.debugFlags.debugRectangles ? "#80ff0000" : "transparent"
	border.width: Config.debugFlags.debugRectangles ? 1 : 0
	default property alias content: container.children

	RowLayout {
		id: container
		anchors.fill: parent
	}
}
