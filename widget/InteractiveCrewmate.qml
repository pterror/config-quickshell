import Quickshell
import QtQuick
import QtMultimedia
import "../component"
import ".."

Crewmate {
	id: root
	property list<string> sounds: [
		"report_body.mp3", "sus.mp3", "vent_in.mp3", "vent_out.mp3", "imposter_stab.mp3"
	]
	property string sound: ""
	property string video: "stop_posting_about_among_us.mp4"
	property int clickCount: 0
	property int maxClickCount: 8
	property bool videoVisible: false
	property alias hoverEnabled: mouseArea.hoverEnabled
	signal canceled()
	signal clicked(MouseEvent mouse)
	signal doubleClicked(MouseEvent mouse)
	signal entered()
	signal exited()
	signal positionChanged(MouseEvent mouse)
	signal pressAndHold(MouseEvent mouse)
	signal pressed(MouseEvent mouse)
	signal released(MouseEvent mouse)
	signal wheel(WheelEvent wheel)

	MediaPlayer { id: audio; source: Config.soundUrl(sound); audioOutput: AudioOutput {} }

	MouseArea {
		id: mouseArea
		anchors.fill: parent
		cursorShape: Qt.PointingHandCursor
		onCanceled: root.canceled()
		onDoubleClicked: event => { root.doubleClicked(event) }
		onEntered: root.entered()
		onExited: root.exited()
		onPositionChanged: event => { root.positionChanged(event) }
		onPressAndHold: event => { root.pressAndHold(event) }
		onPressed: event => { root.pressed(event) }
		onReleased: event => { root.released(event) }
		onWheel: event => { root.wheel(event) }
		onClicked: event => {
			root.clicked(event)
			sound = sounds[Math.floor(Math.random() * sounds.length)]
			audio.play()
			clickCount += 1
			if (clickCount === maxClickCount) {
				videoLoader.loading = true
				videoVisible = true
			}
		}
	}

	LazyLoader {
		id: videoLoader
		PanelWindow {
			visible: videoVisible
			anchors { top: true; bottom: true; left: true; right: true }
			exclusionMode: ExclusionMode.Ignore
			color: "transparent"
			VideoPlayer {
				id: videoPlayer
				loops: 1
				source: Config.videoUrl(video)
				onPlayingChanged: { if (!playing) { videoVisible = false } }

				Connections {
					target: root
					function onVideoVisibleChanged() {
						if (videoVisible) { play() }
					}
				}
			}
		}
	}
}
