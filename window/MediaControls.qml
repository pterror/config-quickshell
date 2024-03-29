import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import "../component"
import "../input"
import ".."

PanelWindow {
	color: "transparent"
	WlrLayershell.namespace: "shell:mediacontrols"
	width: Math.max(content.implicitWidth, 1)
	height: Math.max(content.implicitHeight, 1)

	ColumnLayout2 {
		autoSize: true
		id: content
		radius: Config.layout.panel.radius
		margins: Config.layout.widget.margins
		color: Config.colors.panel.bg
		spacing: Config.layout.mediaPlayer.controlsGap

		Image {
			Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
			width: Config.layout.mediaPlayer.imageSize
			height: Config.layout.mediaPlayer.imageSize
			fillMode: Image.PreserveAspectFit
			source: MPRIS.image.startsWith("file://") ? MPRIS.image : "../" + MPRIS.image
		}

		RowLayout2 {
			Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
			autoSize: true
			spacing: Config.layout.mediaPlayer.controlGap
			Button {
				id: previousButton
				flat: true
				display: AbstractButton.IconOnly
				icon.width: Config.layout.mediaPlayer.controlSize
				icon.height: Config.layout.mediaPlayer.controlSize
				icon.source: "../image/media_previous.svg"
				background: Rectangle {
					anchors.margins: Config.layout.button.margins
					radius: Config.layout.button.radius
					color: previousButton.hovered ? Config.colors.button.hoverBg : Config.colors.button.bg
				}
				MouseArea {
					anchors.fill: parent
					cursorShape: Qt.PointingHandCursor
					onClicked: MPRIS.previous()
				}
			}
			Button {
				id: playButton
				flat: true
				display: AbstractButton.IconOnly
				icon.width: Config.layout.mediaPlayer.controlSize
				icon.height: Config.layout.mediaPlayer.controlSize
				icon.source: MPRIS.playing ? "../image/media_pause.svg" : "../image/media_play.svg"
				background: Rectangle {
					anchors.margins: Config.layout.button.margins
					radius: Config.layout.button.radius
					color: playButton.hovered ? Config.colors.button.hoverBg : Config.colors.button.bg
				}
				MouseArea {
					anchors.fill: parent
					cursorShape: Qt.PointingHandCursor
					onClicked: MPRIS.playing ? MPRIS.pause() : MPRIS.play()
				}
			}
			Button {
				id: nextButton
				flat: true
				display: AbstractButton.IconOnly
				icon.width: Config.layout.mediaPlayer.controlSize
				icon.height: Config.layout.mediaPlayer.controlSize
				icon.source: "../image/media_next.svg"
				background: Rectangle {
					anchors.margins: Config.layout.button.margins
					radius: Config.layout.button.radius
					color: nextButton.hovered ? Config.colors.button.hoverBg : Config.colors.button.bg
				}
				MouseArea {
					anchors.fill: parent
					cursorShape: Qt.PointingHandCursor
					onClicked: MPRIS.previous()
				}
			}
		}
	}
}
