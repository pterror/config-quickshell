import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Services.Mpris
import "root:/component"
import "root:/"

ColumnLayout2 {
	autoSize: true
	radius: Config.style.panel.radius
	margins: Config.style.panel.margins
	spacing: Config.style.mediaPlayer.controlsGap

	RoundedImage {
		size: Config.style.mediaPlayer.imageSize
		source: Config.mpris.currentPlayer?.metadata["mpris:artUrl"] ?? Config.imageUrl("blank.png")
		radius: Config.style.panel.innerRadius
	}

	RowLayout2 {
		Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
		autoSize: true
		spacing: Config.style.mediaPlayer.controlGap
		HoverIcon {
			source: Config.iconUrl("flat/media_previous.svg")
			onClicked: Config.mpris.currentPlayer?.previous()
		}
		HoverIcon {
			property bool playing: Config.mpris.currentPlayer?.playbackState === MprisPlaybackState.Playing
			source: playing ? Config.iconUrl("flat/media_pause.svg") : Config.iconUrl("flat/media_play.svg")
			onClicked: {
				if (!Config.mpris.currentPlayer) return
				Config.mpris.currentPlayer.playbackState = playing ? MprisPlaybackState.Paused : MprisPlaybackState.Playing
			}
		}
		HoverIcon {
			source: Config.iconUrl("flat/media_next.svg")
			onClicked: Config.mpris.currentPlayer?.next()
		}
	}
}
