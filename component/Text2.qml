import QtQuick
import QtQuick.Layouts
import "root:/"

Text {
	Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
	anchors.margins: Config.layout.hBar.margins
	font.family: Config.font.family
	font.pointSize: Config.layout.widget.fontSize
	color: Config.colors.widget.fg
}
