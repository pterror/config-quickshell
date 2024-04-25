import QtQuick
import ".."

Image {
	property string color: "transparent"
	source: Config.imageUrl("crewmate_" + color + ".png")
	width: height * (implicitWidth / implicitHeight)
	height: 240
}
