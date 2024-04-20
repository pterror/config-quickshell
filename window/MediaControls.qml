import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import "../component"
import "../io"
import ".."

PopupWindow {
	color: "transparent"
	width: content.implicitWidth
	height: content.implicitHeight

	ColumnLayout2 {
		id: content
		autoSize: true
		radius: Config.layout.panel.radius
		margins: Config.layout.panel.margins
		color: Config.colors.panel.bg
		spacing: Config.layout.mediaPlayer.controlsGap

		Image {
			Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
			width: Config.layout.mediaPlayer.imageSize
			height: Config.layout.mediaPlayer.imageSize
			fillMode: Image.PreserveAspectFit
			source: MPRIS.image.startsWith("file://") ? MPRIS.image : "../" + MPRIS.image

			layer.enabled: true
			layer.effect: ShaderEffect {
        property real adjustX: Math.max(width / height, 1)
        property real adjustY: Math.max(1 / (width / height), 1)

        fragmentShader: "
        #ifdef GL_ES
            precision lowp float;
        #endif // GL_ES
        varying highp vec2 qt_TexCoord0;
        uniform highp float qt_Opacity;
        uniform lowp sampler2D source;
        uniform lowp float adjustX;
        uniform lowp float adjustY;

        void main(void) {
            lowp float x, y;
            x = (qt_TexCoord0.x - 0.5) * adjustX;
            y = (qt_TexCoord0.y - 0.5) * adjustY;
            float delta = adjustX != 1.0 ? fwidth(y) / 2.0 : fwidth(x) / 2.0;
            gl_FragColor = texture2D(source, qt_TexCoord0).rgba
                * step(x * x + y * y, 0.25)
                * smoothstep((x * x + y * y) , 0.25 + delta, 0.25)
                * qt_Opacity;
        }"
    }
		}

		RowLayout2 {
			Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
			autoSize: true
			spacing: Config.layout.mediaPlayer.controlGap
			HoverIcon {
				source: "../icon/flat/media_previous.svg"
				onClicked: MPRIS.previous()
			}
			HoverIcon {
				source: MPRIS.playing ? "../icon/flat/media_pause.svg" : "../icon/flat/media_play.svg"
				onClicked: MPRIS.playing ? MPRIS.pause() : MPRIS.play()
			}
			HoverIcon {
				source: "../icon/flat/media_next.svg"
				onClicked: MPRIS.next()
			}
		}
	}
}
