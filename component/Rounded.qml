import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import "root:/"

Rectangle {
	id: root
	default property Component contentDelegate
	Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
	property alias radius: mask.radius
	property int size: 256
	property real aspectRatio: (content.implicitWidth / content.implicitHeight) || 0.01
	property bool enabled: true
	color: "transparent"
	implicitWidth: size * Math.min(aspectRatio, 1)
	implicitHeight: size / Math.max(aspectRatio, 1)

	Loader {
		id: content
		visible: !root.enabled
		sourceComponent: contentDelegate
		anchors.fill: parent
	}

	Rectangle {
		id: mask
		visible: root.enabled
		layer.enabled: root.enabled
		width: content.width; height: content.height
		radius: Config._.style.panel.innerRadius
		color: "black"
	}

	MultiEffect {
		visible: root.enabled
		source: content
		anchors.fill: parent
		maskEnabled: root.enabled
		maskSource: mask
	}
}
