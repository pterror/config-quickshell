import QtQuick
import QtQuick.Layouts
import "root:/"

Text {
	Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
	anchors.margins: Config.style.hBar.margins
	font.family: Config.font.family
	font.pointSize: Config.style.widget.fontSize
	color: Config.style.widget.fg
}
