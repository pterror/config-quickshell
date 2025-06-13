import QtQuick
import "root:/"

Widget {
	color: mouseArea.containsMouse ? Config.style.widget.hoverBg : Config.style.widget.bg
	MouseArea {
		id: mouseArea
		anchors.fill: parent
		hoverEnabled: true
	}
}
