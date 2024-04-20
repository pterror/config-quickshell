import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import ".."

Rectangle {
	id: root
	Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
	property alias source: image.source
	property alias radius: mask.radius
	property int size: 256
	property real aspectRatio: (image.implicitWidth / image.implicitHeight) || 0

	color: "transparent"
	implicitWidth: Config.layout.mediaPlayer.imageSize * Math.min(aspectRatio, 1)
	implicitHeight: Config.layout.mediaPlayer.imageSize * Math.min(1 / aspectRatio, 1)

	Image {
		id: image
		anchors.fill: parent
		visible: false
	}

	Rectangle {
		id: mask
		layer.enabled: true
		width: image.width
		height: image.height
		radius: Config.layout.panel.innerRadius
		color: "black"
	}

	MultiEffect {
		source: image
		anchors.fill: parent
		maskEnabled: true
		maskSource: mask
	}
}
