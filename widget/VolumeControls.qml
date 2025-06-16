import QtQuick
import QtQuick.Layouts
import Quickshell
import "root:/component"
import "root:/io"
import "root:/"

RowLayout2 {
	id: content
	autoSize: true
	radius: Config._.style.panel.radius
	margins: Config._.style.panel.margins
	spacing: 16

	ColumnLayout2 {
		autoSize: true
		VProgressBar {
			fraction: Config._.services.audio.volume
			width: 48
			height: 224
			onInput: fraction => Config._.services.audio.setVolume(fraction)
		}
		HoverIcon {
			Layout.alignment: Qt.AlignHCenter
			source: Config._.services.audio.muted ? Config.iconUrl("flat/speaker_muted.svg") :
				Config._.services.audio.volume < 0.25 ? Config.iconUrl("flat/speaker_volume_very_low.svg") :
				Config._.services.audio.volume < 0.50 ? Config.iconUrl("flat/speaker_volume_low.svg") :
				Config._.services.audio.volume < 0.75 ? Config.iconUrl("flat/speaker_volume_medium.svg") :
				Config.iconUrl("flat/speaker_volume_high.svg")
			onClicked: Config._.services.audio.toggleMute()
		}
	}

	ColumnLayout2 {
		autoSize: true
		VProgressBar {
			fraction: Config._.services.audio.micVolume
			width: 48
			height: 224
			onInput: fraction => Config._.services.audio.setMicVolume(fraction)
		}
		HoverIcon {
			Layout.alignment: Qt.AlignHCenter
			source: Config._.services.audio.micMuted ? Config.iconUrl("flat/microphone_muted.svg") : Config.iconUrl("flat/microphone.svg")
			onClicked: Config._.services.audio.toggleMicMute()
		}
	}
}
