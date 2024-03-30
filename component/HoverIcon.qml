import QtQuick
import QtQuick.Controls
import ".."

Button {
	id: root
	required property string source
	signal clicked()
	flat: true
	display: AbstractButton.IconOnly
	icon.width: Config.layout.iconButton.size
	icon.height: Config.layout.iconButton.size
	icon.source: source
	background: Rectangle {
		anchors.margins: Config.layout.button.margins
		radius: Config.layout.button.radius
		color: root.hovered ? Config.colors.button.hoverBg : Config.colors.button.bg
	}
	MouseArea {
		id: mouseArea
		anchors.fill: parent
		cursorShape: Qt.PointingHandCursor
		onClicked: root.clicked()
	}
}
