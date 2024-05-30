import Quickshell
import Quickshell.Wayland
import QtQuick
import QtMultimedia
import "../component"
import ".."

Crewmate {
	id: root
	property list<var> sounds: [
		"report_body.mp3", "sus.mp3", "vent_in.mp3", "vent_out.mp3", "imposter_stab.mp3"
	]
	property var sound: ""
	property var video: "stop_posting_about_among_us.mp4"
	property int clickCount: 0
	property int maxClickCount: 8
	property bool videoVisible: false
	property bool moveable: true
	property int startX: 0
	property int startY: 0
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

	onPressed: event => { startX = event.x; startY = event.y }
	onPositionChanged: event => {
		if (moveable) {
			root.anchors.leftMargin += event.x - startX
			root.anchors.topMargin += event.y - startY
		}
	}

	MediaPlayer { id: audio; source: Config.soundUrl(sound); audioOutput: AudioOutput {} }

	scale: mouseArea.pressed ? 0.9 : 1.0
	Behavior on scale { SmoothedAnimation { velocity: 2 } }

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
			if (clickCount === maxClickCount) videoLock.locked = true
		}
	}

	WlSessionLock {
		id: videoLock

		WlSessionLockSurface {
			id: lockSurface
			color: "black"

			Video {
				id: videoPlayer
				anchors.fill: parent
				loops: 1
				source: Config.videoUrl(video)
				fillMode: VideoOutput.PreserveAspectFit
				onStopped: videoLock.locked = false

				Connections {
					target: videoLock

					function onSecureChanged() {
						videoPlayer.muted = lockSurface.screen != Quickshell.screens[0]
						videoPlayer.play()
					}
				}
			}
		}
	}
}
