import QtQuick
import Quickshell
import Quickshell.Wayland
import "root:/"

WlrLayershell {
	property var selectionArea: area
	signal selectionComplete(x: real, y: real, width: real, height: real)
	color: "transparent"
	visible: selectionArea.selecting || selectionArea.initializing
	exclusionMode: ExclusionMode.Ignore
	layer: WlrLayer.Overlay
	namespace: "termspawner"
	anchors { left: true; right: true; top: true; bottom: true }

	Rectangle {
		id: area
		property bool selecting: false
		property bool initializing: false
		property bool locked: false
		property real startX: 0
		property real startY: 0
		property real endX: 0
		property real endY: 0

		readonly property bool bigEnough: width > 300 && height > 150

		color: Config._.style.selection.bg
		radius: Config._.style.selection.radius
		border.color: bigEnough ? Config._.style.selection.outline : Config._.style.selection.outlineInvalid
		border.width: Config._.style.selection.border
		visible: selecting

		x: Math.min(startX, endX) - border.width
		y: Math.min(startY, endY) - border.width
		width: Math.max(startX, endX) - x + border.width * 2
		height: Math.max(startY, endY) - y + border.width * 2

		function startSelection(initialize: bool) {
			locked = false
			if (!initialize) { selecting = true; return }
			initializing = true
			if (selecting) {
				area.startX = mouseArea.mouseX
				area.startY = mouseArea.mouseY
				area.endX = mouseArea.mouseX
				area.endY = mouseArea.mouseY
			}
		}

		function endSelection() {
			initializing = false
			if (selecting && bigEnough) {
				locked = true
				selectionComplete(x + 1, y + 1, width - 2, height - 2)
			} else {
				selecting = false
			}
		}
	}

	MouseArea {
		id: mouseArea
		anchors.fill: parent

		hoverEnabled: true
		onPositionChanged: {
			if (area.initializing) {
				if (!containsMouse) { area.initializing = false; return }
				area.startX = mouseX
				area.startY = mouseY
				area.initializing = false
				area.selecting = true
			}
			if (!selectionArea.locked) {
				area.endX = mouseX
				area.endY = mouseY
			}
		}
	}
}
