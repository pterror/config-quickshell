import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Services.Mpris
import "root:/component"
import ".."

ColumnLayout2 {
	autoSize: true
	radius: Config.layout.panel.radius
	margins: Config.layout.panel.margins
	spacing: Config.layout.mediaPlayer.controlsGap

	RoundedImage {
		size: Config.layout.mediaPlayer.imageSize
		source: Config.mpris.currentPlayer?.metadata["mpris:artUrl"] ?? Config.imageUrl("blank.png")
		radius: Config.layout.panel.innerRadius
	}

	RowLayout2 {
		Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
		autoSize: true
		spacing: Config.layout.mediaPlayer.controlGap
		HoverIcon {
			source: Config.iconUrl("flat/media_previous.svg")
			onClicked: Config.mpris.currentPlayer?.previous()
		}
		HoverIcon {
			property bool playing: Config.mpris.currentPlayer?.playbackState === MprisPlaybackState.Playing
			source: playing ? Config.iconUrl("flat/media_pause.svg") : Config.iconUrl("flat/media_play.svg")
		onPressed: {
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
