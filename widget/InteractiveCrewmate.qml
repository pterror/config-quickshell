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

	MediaPlayer { id: audio; source: Config.soundUrl(sound); audioOutput: AudioOutput {} }

	MouseArea {
		anchors.fill: parent
		cursorShape: Qt.PointingHandCursor
		onClicked: {
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
			color: "transparent"
			VideoPlayer {
				id: videoPlayer
				loops: 1
				source: Config.videoUrl(video)
				onPlayingChanged: { if (!playing) { videoVisible = false; } }

				Connections {
					target: root
					function onVideoVisibleChanged() {
						if (videoVisible) { play(); }
					}
				}
			}
		}
	}
}
