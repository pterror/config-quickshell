import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import Quickshell
import "../component"
import "../io"
import ".."

PopupWindow {
	color: "transparent"
	width: content.implicitWidth
	height: content.implicitHeight

	ColumnLayout2 {
		id: content
		autoSize: true
		radius: Config.layout.panel.radius
		margins: Config.layout.panel.margins
		color: Config.colors.panel.bg
		spacing: Config.layout.mediaPlayer.controlsGap

		Rectangle {
			Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
			color: "transparent"
			property real aspectRatio: (image.implicitWidth / image.implicitHeight) || 0
			implicitWidth: Config.layout.mediaPlayer.imageSize * Math.min(aspectRatio, 1)
			implicitHeight: Config.layout.mediaPlayer.imageSize * Math.min(1 / aspectRatio, 1)

			Image {
				id: image
				anchors.fill: parent
				source: MPRIS.image.startsWith("file://") ? MPRIS.image : "../" + MPRIS.image
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
				Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
				source: image
				anchors.fill: parent
				maskEnabled: true
				maskSource: mask
			}
		}

		RowLayout2 {
			Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
			autoSize: true
			spacing: Config.layout.mediaPlayer.controlGap
			HoverIcon {
				source: "../icon/flat/media_previous.svg"
				onClicked: MPRIS.previous()
			}
			HoverIcon {
				source: MPRIS.playing ? "../icon/flat/media_pause.svg" : "../icon/flat/media_play.svg"
				onClicked: MPRIS.playing ? MPRIS.pause() : MPRIS.play()
			}
			HoverIcon {
				source: "../icon/flat/media_next.svg"
				onClicked: MPRIS.next()
			}
		}
	}
}
