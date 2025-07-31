import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.component
import qs.io
import qs

RowLayout {
	id: content
	radius: Config._.style.panel.radius
	margins: Config._.style.panel.margins
	spacing: 16

	ColumnLayout {
		VProgressBar {
			fraction: Config.services.audio.volume
			width: 48
			height: 224
			onInput: fraction => Config.services.audio.setVolume(fraction)
		}

		HoverIcon {
			Layout.alignment: Qt.AlignHCenter
			source: Config.services.audio.muted ? Config.iconUrl("flat/speaker_muted.svg") :
				Config.services.audio.volume < 0.25 ? Config.iconUrl("flat/speaker_volume_very_low.svg") :
				Config.services.audio.volume < 0.50 ? Config.iconUrl("flat/speaker_volume_low.svg") :
				Config.services.audio.volume < 0.75 ? Config.iconUrl("flat/speaker_volume_medium.svg") :
				Config.iconUrl("flat/speaker_volume_high.svg")
			onClicked: Config.services.audio.toggleMute()
		}
	}

	ColumnLayout {
		VProgressBar {
			fraction: Config.services.audio.micVolume
			width: 48
			height: 224
			onInput: fraction => Config.services.audio.setMicVolume(fraction)
		}

		HoverIcon {
			Layout.alignment: Qt.AlignHCenter
			source: Config.services.audio.micMuted ? Config.iconUrl("flat/microphone_muted.svg") : Config.iconUrl("flat/microphone.svg")
			onClicked: Config.services.audio.toggleMicMute()
		}
	}
}
