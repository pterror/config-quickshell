import QtQuick
import QtQuick.Layouts
import ".."

MouseArea {
	required property var inner
	default property alias content: rectangle.children

	id: root
	Layout.fillHeight: true
	Layout.fillWidth: true
	implicitWidth: inner.implicitWidth
	implicitHeight: inner.implicitHeight
	cursorShape: Qt.PointingHandCursor
	hoverEnabled: true

	Rectangle {
		id: rectangle
		anchors.fill: parent
		radius: Config.layout.barItem.radius
		color: root.containsMouse ? Config.colors.barItem.hoverBg : Config.colors.barItem.bg
		Behavior on color { PropertyAnimation { duration: 100 } }
	}
}
