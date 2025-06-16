import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import "root:/"

Rectangle {
	id: root
	Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
	property alias source: image.source
	property alias radius: mask.radius
	property int size: 256
	property real aspectRatio: (image.implicitWidth / image.implicitHeight) || 0.01

	color: "transparent"
	implicitWidth: Config._.style.mediaPlayer.imageSize * Math.min(aspectRatio, 1)
	implicitHeight: Config._.style.mediaPlayer.imageSize / Math.max(aspectRatio, 1)

	Image { id: image; anchors.fill: parent; visible: false; cache: false }

	Rectangle {
		id: mask
		layer.enabled: true
		width: image.width; height: image.height
		radius: Config._.style.panel.innerRadius
		color: "black"
	}

	MultiEffect { source: image; anchors.fill: parent; maskEnabled: true; maskSource: mask }
}
