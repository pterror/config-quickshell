import QtQuick
import QtMultimedia

// requires QtMultimedia to be installed
VideoOutput {
	id: root
  property alias source: mediaPlayer.source 
  property alias loops: mediaPlayer.loops
  property alias autoPlay: mediaPlayer.autoPlay
	anchors.fill: parent
	fillMode: Image.PreserveAspectCrop

  MediaPlayer {
    id: mediaPlayer
    videoOutput: root
    loops: MediaPlayer.Infinite
		autoPlay: true
  }
}