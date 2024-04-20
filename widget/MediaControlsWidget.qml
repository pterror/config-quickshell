import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../component"
import "../io"
import ".."

ColumnLayout2 {
	autoSize: true
	radius: Config.layout.panel.radius
	margins: Config.layout.panel.margins
	spacing: Config.layout.mediaPlayer.controlsGap

	RoundedImage {
		size: Config.layout.mediaPlayer.imageSize
		source: MPRIS.image
		radius: Config.layout.panel.innerRadius
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
