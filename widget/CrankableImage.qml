import Quickshell
import Quickshell.Wayland
import QtQuick
import qs

Rectangle {
	id: root
	property alias source: image.source
	property var crankImage: "hand_crank.svg"
	property real crankX: 100
	property real crankY: 100
	property real crankOpacity: Config._.crankableImage.opacity
	property real angle: 0
	property real ratio: 10
	anchors.fill: parent
	required property var screen

	Image {
		id: image
		asynchronous: true
		cache: false
		scale: Math.hypot(parent.width, parent.height) / (Math.min(sourceSize.width, sourceSize.height) || 1)
		x: (parent.width - sourceSize.width) / 2
		y: (parent.height - sourceSize.height) / 2
		rotation: -root.angle
	}

	LazyLoader {
		loading: root.screen !== undefined
		PanelWindow {
			WlrLayershell.layer: WlrLayer.Bottom
			id: crankWindow
			screen: root.screen
			color: "transparent"
			anchors.left: true; anchors.top: true
			margins.left: root.crankX; margins.top: root.crankY
			width: crank.implicitWidth
			height: crank.implicitHeight

			Image {
				id: crank
				cache: false
				source: Config.imageUrl(crankImage)
				opacity: crankOpacity
				transform: Rotation {
					origin.x: width / 2; origin.y: height / 2; axis { x: 0; y: 0; z: 1 }
					angle: -root.angle * root.ratio
				}
			}

			MouseArea {
				anchors.fill: parent
				cursorShape: Qt.PointingHandCursor
				property real prevAngle: 0
				property real endAngle: 0
				onPressed: updateAngle(true)
				onPositionChanged: updateAngle()

				function updateAngle(initial) {
					const x = mouseX - width / 2
					const y = mouseY - height / 2
					endAngle = Math.atan2(-y, x) * 180 / Math.PI - 90
					if (!initial) {
						if (endAngle - prevAngle > 180) prevAngle += 360
						else if (prevAngle - endAngle > 180) prevAngle -= 360
						root.angle += (endAngle - prevAngle) / root.ratio
					}
					prevAngle = endAngle
				}
			}
		}
	}
}
