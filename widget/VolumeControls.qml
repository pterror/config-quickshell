import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.component
import qs.io
import qs

Item {
	id: root
	property var config: Config.services.audio
	implicitWidth: content.implicitWidth + Config._.style.panel.margins * 2
	implicitHeight: content.implicitHeight + Config._.style.panel.margins * 2

	RowLayout {
		id: content
		anchors.fill: parent
		anchors.margins: Config._.style.panel.margins
		spacing: 16

		ColumnLayout {
			VProgressBar {
				Layout.alignment: Qt.AlignHCenter
				fraction: root.config.volume
				width: 48
				height: 224
				onInput: fraction => root.config.setVolume(fraction)
			}

			Text {
				Layout.alignment: Qt.AlignHCenter
				text: root.config.name ?? qsTr("No audio device")
			}

			HoverIcon {
				Layout.alignment: Qt.AlignHCenter
				source: root.config.muted ? Config.iconUrl("flat/speaker_muted.svg") :
					root.config.volume < 0.25 ? Config.iconUrl("flat/speaker_volume_very_low.svg") :
					root.config.volume < 0.50 ? Config.iconUrl("flat/speaker_volume_low.svg") :
					root.config.volume < 0.75 ? Config.iconUrl("flat/speaker_volume_medium.svg") :
					Config.iconUrl("flat/speaker_volume_high.svg")
				onClicked: root.config.toggleMute()
			}
		}

		ColumnLayout {
			VProgressBar {
				Layout.alignment: Qt.AlignHCenter
				fraction: root.config.micVolume
				width: 48
				height: 224
				onInput: fraction => root.config.setMicVolume(fraction)
			}

			Text {
				Layout.alignment: Qt.AlignHCenter
				text: root.config.micName ?? qsTr("No microphone")
			}

			HoverIcon {
				Layout.alignment: Qt.AlignHCenter
				source: root.config.micMuted ? Config.iconUrl("flat/microphone_muted.svg") : Config.iconUrl("flat/microphone.svg")
				onClicked: root.config.toggleMicMute()
			}
		}
	}
}
