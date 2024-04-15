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
				fraction: Config.services.audio.volume * 0.01
				width: 48
				height: 224
				onInput: fraction => Config.services.audio.setVolume(fraction * 100)
			}
			HoverIcon {
				Layout.alignment: Qt.AlignHCenter
				source: Config.services.audio.muted ? "../icon/flat/speaker_muted.svg" :
					Config.services.audio.volume < 25 ? "../icon/flat/speaker_volume_very_low.svg" :
					Config.services.audio.volume < 50 ? "../icon/flat/speaker_volume_low.svg" :
					Config.services.audio.volume < 75 ? "../icon/flat/speaker_volume_medium.svg" :
					"../icon/flat/speaker_volume_high.svg"
				onClicked: Config.services.audio.toggleMute()
			}
		}

		ColumnLayout2 {
			autoSize: true
			VProgressBar {
				fraction: Config.services.audio.micVolume * 0.01
				width: 48
				height: 224
				onInput: fraction => Config.services.audio.setMicVolume(fraction * 100)
			}
			HoverIcon {
				Layout.alignment: Qt.AlignHCenter
				source: Config.services.audio.micMuted ? "../icon/flat/microphone_muted.svg" : "../icon/flat/microphone.svg"
				onClicked: Config.services.audio.toggleMicMute()
			}
		}
	}
}
