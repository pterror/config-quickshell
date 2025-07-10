import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Widgets
import Quickshell.Services.Mpris
import qs.component
import qs

ColumnLayout2 {
	autoSize: true
	radius: Config._.style.panel.radius
	margins: Config._.style.panel.margins
	spacing: Config._.style.mediaPlayer.controlsGap

	ClippingRectangle {
		radius: Config._.style.panel.innerRadius
		property real aspectRatio: (image.implicitWidth / image.implicitHeight) || 0.01
		implicitWidth: Config._.style.mediaPlayer.imageSize * Math.min(aspectRatio, 1)
		implicitHeight: Config._.style.mediaPlayer.imageSize / Math.max(aspectRatio, 1)

		Image {
			id: image
			anchors.fill: parent
			cache: false
			source: Config.mpris.currentPlayer?.metadata["mpris:artUrl"] ?? Config.imageUrl("blank.png")
		}
	}

	RowLayout2 {
		Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
		autoSize: true
		spacing: Config._.style.mediaPlayer.controlGap
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
