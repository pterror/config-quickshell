import QtQuick as Q
import QtQuick.Layouts
import qs

Q.Text {
	Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
	anchors.margins: Config._.style.hBar.margins
	font.family: Config._.font.family
	font.pointSize: Config._.style.widget.fontSize
	color: Config._.style.widget.fg
}
