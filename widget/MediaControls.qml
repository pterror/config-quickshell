import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Services.Mpris
import "root:/component"
import "root:/"

ColumnLayout2 {
	autoSize: true
	radius: Config._.style.panel.radius
	margins: Config._.style.panel.margins
	spacing: Config._.style.mediaPlayer.controlsGap

	Rounded {
		size: Config._.style.mediaPlayer.imageSize
		radius: Config._.style.panel.innerRadius

		Image {
			cache: false
			source: Config._.mpris.currentPlayer?.metadata["mpris:artUrl"] ?? Config.imageUrl("blank.png")
		}
	}

	RowLayout2 {
		Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
		autoSize: true
		spacing: Config._.style.mediaPlayer.controlGap
		HoverIcon {
			source: Config.iconUrl("flat/media_previous.svg")
			onClicked: Config._.mpris.currentPlayer?.previous()
		}
		HoverIcon {
			property bool playing: Config._.mpris.currentPlayer?.playbackState === MprisPlaybackState.Playing
			source: playing ? Config.iconUrl("flat/media_pause.svg") : Config.iconUrl("flat/media_play.svg")
			onClicked: {
				if (!Config._.mpris.currentPlayer) return
				Config._.mpris.currentPlayer.playbackState = playing ? MprisPlaybackState.Paused : MprisPlaybackState.Playing
			}
		}
		HoverIcon {
			source: Config.iconUrl("flat/media_next.svg")
			onClicked: Config._.mpris.currentPlayer?.next()
		}
	}
}
