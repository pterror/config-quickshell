import QtQuick
import "root:/"

Widget {
	color: mouseArea.containsMouse ? Config.colors.widget.hoverBg : Config.colors.widget.bg
	MouseArea {
		id: mouseArea
		anchors.fill: parent
		hoverEnabled: true
	}
}
