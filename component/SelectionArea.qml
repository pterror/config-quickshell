import QtQuick

MouseArea {
	required property var screen
	required property var selectionArea
	signal selectionComplete(x: real, y: real, width: real, height: real)
	anchors.fill: parent

	onReleased: selectionArea.endSelection()

	onPressed: {
		selectionArea.startX = mouseX
		selectionArea.startY = mouseY
		selectionArea.endX = mouseX
		selectionArea.endY = mouseY
		selectionArea.startSelection(false)
	}

	onPositionChanged: {
		selectionArea.endX = mouseX
		selectionArea.endY = mouseY
	}
}
