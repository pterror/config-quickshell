import QtQuick
import QtQuick.Controls
import ".."

Rectangle {
	id: root
	required property string source
	readonly property int size: Config.layout.iconButton.size + Config.layout.button.margins * 2
	signal clicked()
	radius: Config.layout.button.radius
	width: size
	height: size
	color: mouseArea.containsMouse ? Config.colors.button.hoverBg : Config.colors.button.bg

	Image {
		readonly property int size: Config.layout.iconButton.size
		anchors.fill: parent
		anchors.margins: Config.layout.button.margins
		source: root.source
		width: size
		height: size
		opacity: Config.iconOpacity
		sourceSize: Qt.size(width, height)
	}

	MouseArea {
		id: mouseArea
		anchors.fill: parent
		hoverEnabled: true
		cursorShape: Qt.PointingHandCursor
		onClicked: root.clicked()
	}
}
