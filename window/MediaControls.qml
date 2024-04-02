import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import "../component"
import "../input"
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

		Image {
			Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
			width: Config.layout.mediaPlayer.imageSize
			height: Config.layout.mediaPlayer.imageSize
			fillMode: Image.PreserveAspectFit
			source: MPRIS.image.startsWith("file://") ? MPRIS.image : "../" + MPRIS.image
		}

		RowLayout2 {
			Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
			autoSize: true
			spacing: Config.layout.mediaPlayer.controlGap
			HoverIcon {
				source: "../image/media_previous.png"
				onClicked: MPRIS.previous()
			}
			HoverIcon {
				source: MPRIS.playing ? "../image/media_pause.png" : "../image/media_play.png"
				onClicked: MPRIS.playing ? MPRIS.pause() : MPRIS.play()
			}
			HoverIcon {
				source: "../image/media_next.png"
				onClicked: MPRIS.next()
			}
		}
	}
}
