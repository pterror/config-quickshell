import QtQuick
import qs

Image {
	property string color: "transparent"
	source: Config.imageUrl("crewmate_" + color + ".png")
	width: height * (implicitWidth / implicitHeight)
	height: 240
	cache: false
}
