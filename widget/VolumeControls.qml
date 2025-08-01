import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.component
import qs.io
import qs

RowLayout {
	id: content
	property var config: Config.services.audio
	radius: Config._.style.panel.radius
	margins: Config._.style.panel.margins
	spacing: 16

	ColumnLayout {
		VProgressBar {
			Layout.alignment: Qt.AlignHCenter
			fraction: config.volume
			width: 48
			height: 224
			onInput: fraction => config.setVolume(fraction)
		}

		Text {
			Layout.alignment: Qt.AlignHCenter
			text: config.name ?? qsTr("No audio device")
		}

		HoverIcon {
			Layout.alignment: Qt.AlignHCenter
			source: config.muted ? Config.iconUrl("flat/speaker_muted.svg") :
				config.volume < 0.25 ? Config.iconUrl("flat/speaker_volume_very_low.svg") :
				config.volume < 0.50 ? Config.iconUrl("flat/speaker_volume_low.svg") :
				config.volume < 0.75 ? Config.iconUrl("flat/speaker_volume_medium.svg") :
				Config.iconUrl("flat/speaker_volume_high.svg")
			onClicked: config.toggleMute()
		}
	}

	ColumnLayout {
		VProgressBar {
			Layout.alignment: Qt.AlignHCenter
			fraction: config.micVolume
			width: 48
			height: 224
			onInput: fraction => config.setMicVolume(fraction)
		}

		Text {
			Layout.alignment: Qt.AlignHCenter
			text: config.micName ?? qsTr("No microphone")
		}

		HoverIcon {
			Layout.alignment: Qt.AlignHCenter
			source: config.micMuted ? Config.iconUrl("flat/microphone_muted.svg") : Config.iconUrl("flat/microphone.svg")
			onClicked: config.toggleMicMute()
		}
	}
}
