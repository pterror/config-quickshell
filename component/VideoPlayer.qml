import QtQuick
import QtMultimedia

VideoOutput {
	id: root
	property alias source: mediaPlayer.source 
	property alias loops: mediaPlayer.loops
	property alias autoPlay: mediaPlayer.autoPlay
	property alias playbackState: mediaPlayer.playbackState
	property alias playing: mediaPlayer.playing
	anchors.fill: parent
	fillMode: Image.PreserveAspectCrop
	signal onErrorOccurred(var error, string errorString)

	MediaPlayer {
		id: mediaPlayer
		videoOutput: root
		audioOutput: AudioOutput {}
		loops: MediaPlayer.Infinite
		autoPlay: true
		onErrorOccurred: (error, errorString) => { root.error(error, errorString); }
		onPlaybackStateChanged: root.playbackStateChanged()
		onPlayingChanged: root.playingChanged()
	}
}
