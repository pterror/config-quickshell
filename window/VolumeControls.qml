import QtQuick
import QtQuick.Layouts
import Quickshell
import "../component"
import "../input"
import ".."

PopupWindow {
	color: "transparent"
	width: content.implicitWidth
	height: content.implicitHeight

	RowLayout2 {
		id: content
		autoSize: true
		radius: Config.layout.panel.radius
		margins: Config.layout.panel.margins
		color: Config.colors.panel.bg
		spacing: 16

		ColumnLayout2 {
			autoSize: true
			VProgressBar {
				fraction: PulseAudio.volume * 0.01
				width: 48
				height: 224
				onInput: fraction => PulseAudio.setVolume(fraction * 100)
			}
			HoverIcon {
				Layout.alignment: Qt.AlignHCenter
				source: PulseAudio.muted ? "../image/speaker_muted.png" :
					PulseAudio.volume < 25 ? "../image/speaker_volume_very_low.png" :
					PulseAudio.volume < 50 ? "../image/speaker_volume_low.png" :
					PulseAudio.volume < 75 ? "../image/speaker_volume_medium.png" :
					"../image/speaker_volume_high.png"
				onClicked: PulseAudio.toggleMute()
			}
		}

		ColumnLayout2 {
			autoSize: true
			VProgressBar {
				fraction: PulseAudio.micVolume * 0.01
				width: 48
				height: 224
				onInput: fraction => PulseAudio.setMicVolume(fraction * 100)
			}
			HoverIcon {
				Layout.alignment: Qt.AlignHCenter
				source: PulseAudio.micMuted ? "../image/microphone_muted.png" : "../image/microphone.png"
				onClicked: PulseAudio.toggleMicMute()
			}
		}
	}
}
