import QtQuick
import "root:/"

Rectangle {
	anchors.margins: Config._.style.widget.margins
	color: Config._.style.widget.bg
	radius: Config._.style.widget.radius
	border.color: Config._.style.widget.outline
	border.width: Config._.style.widget.border
}
