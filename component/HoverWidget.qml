import QtQuick
import "root:/"

Widget {
	color: mouseArea.containsMouse ? Config._.style.widget.hoverBg : Config._.style.widget.bg
	MouseArea {
		id: mouseArea
		anchors.fill: parent
		hoverEnabled: true
	}
}
