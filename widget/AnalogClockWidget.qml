import QtQuick
import "../library"
import ".."

Rectangle {
	id: root
	property int radius: 128
	property int tickHeight: 24
	property int tickWidth: 6
	property int tickRadius: 2
	property bool secondHandVisible: true
	property bool minuteHandVisible: true
	property bool hourHandVisible: true
	property real actualSecondAngle: -(Number(new Date()) / 1000 % 60 * (360 / 60))
	property real actualMinuteAngle: -(Number(Time.time) / 60000 % 60 * (360 / 60))
	property real actualHourAngle: -((Number(Time.time) - Time.time.getTimezoneOffset() * 60000) / 3600000 % 24 * (360 / 12))
	property real secondAngle: actualSecondAngle
	property real minuteAngle: actualMinuteAngle
	property real hourAngle: actualHourAngle
	property int frameRate: Config.frameRate
	property real minAmplitude: 0.1
	property real dragDecay: 0.2
	property bool hourDragged: false
	property real hourDragAmplitude: 0
	property real hourDragAngle: 0
	property real hourDragStartTime: 0
	property real hourDragDecay: dragDecay
	property real hourDragDecayFrame: Math.pow(hourDragDecay, 1 / frameRate)
	property bool minuteDragged: false
	property real minuteDragAmplitude: 0
	property real minuteDragAngle: 0
	property real minuteDragStartTime: 0
	property real minuteDragDecay: dragDecay
	property real minuteDragDecayFrame: Math.pow(minuteDragDecay, 1 / frameRate)
	property bool secondDragged: false
	property real secondDragAmplitude: 0
	property real secondDragAngle: 0
	property real secondDragStartTime: 0
	property real secondDragDecay: dragDecay
	property real secondDragDecayFrame: Math.pow(secondDragDecay, 1 / frameRate)
	implicitWidth: radius * 2
	implicitHeight: radius * 2
	color: "transparent"

	FrameAnimation {
		running: secondHandVisible || hourDragged || minuteDraged || secondDragged
		onTriggered: {
			actualSecondAngle = -(Number(new Date()) / 1000 % 60 * (360 / 60))
			if (hourDragged) {
				hourDragAmplitude *= hourDragDecayFrame
				const deltaTime = (new Date() - hourDragStartTime) / 1000
				const delta = hourDragAmplitude * Math.cos(deltaTime * 2 * Math.PI)
				hourAngle = actualHourAngle + delta
				if (Math.abs(hourDragAmplitude) < minAmplitude) {
					hourAngle = Qt.binding(() => actualHourAngle)
					hourDragged = false
				}
			}
			if (minuteDragged) {
				minuteDragAmplitude *= minuteDragDecayFrame
				const deltaTime = (new Date() - minuteDragStartTime) / 1000
				const delta = minuteDragAmplitude * Math.cos(deltaTime * 2 * Math.PI)
				minuteAngle = actualMinuteAngle + delta
				if (Math.abs(minuteDragAmplitude) < minAmplitude) {
					minuteAngle = Qt.binding(() => actualMinuteAngle)
					minuteDragged = false
				}
			}
			if (secondDragged) {
				secondDragAmplitude *= secondDragDecayFrame
				const deltaTime = (new Date() - secondDragStartTime) / 1000
				const delta = secondDragAmplitude * Math.cos(deltaTime * 2 * Math.PI)
				secondAngle = actualSecondAngle + delta
				if (Math.abs(secondDragAmplitude) < minAmplitude) {
					secondAngle = Qt.binding(() => actualSecondAngle)
					secondDragged = false
				}
			}
		}
	}

	Rectangle {
		visible: hourHandVisible
		width: root.tickWidth
		height: root.tickHeight
		radius: tickRadius
		property int innerRadius: root.radius - tickHeight * 2
		color: Config.colors.widget.accent
		x: root.radius + innerRadius * Math.cos((-root.hourAngle - 90) * Math.PI / 180)
		y: root.radius + innerRadius * Math.sin((-root.hourAngle - 90) * Math.PI / 180)
		transform: Rotation {
			origin.x: root.tickWidth / 2; origin.y: 0
			axis { x: 0; y: 0; z: 1 }
			angle: -root.hourAngle
		}
		MouseArea {
			anchors.fill: parent
			anchors.leftMargin: -8
			anchors.rightMargin: -8
			cursorShape: Qt.PointingHandCursor
			onReleased: {
				hourDragged = true
				hourDragStartTime = Number(new Date())
				hourDragAmplitude = hourAngle - actualHourAngle
			}
			onPositionChanged: {
				const coord = mapToItem(root, mouseX, mouseY)
				const x = coord.x - radius
				const y = coord.y - radius
				const rawAngle = Math.atan2(-x, -y) * 180 / Math.PI
				const rawAngle2 = Math.floor(hourAngle / 360 + 0.5) * 360 + rawAngle
				hourAngle = rawAngle2 + 180 < hourAngle ? rawAngle2 + 360 : rawAngle2
			}
		}
	}

	Rectangle {
		visible: minuteHandVisible
		width: root.tickWidth
		height: root.tickHeight
		radius: tickRadius
		property int innerRadius: root.radius - tickHeight
		color: Config.colors.widget.accent
		x: root.radius + innerRadius * Math.cos((-root.minuteAngle - 90) * Math.PI / 180)
		y: root.radius + innerRadius * Math.sin((-root.minuteAngle - 90) * Math.PI / 180)
		transform: Rotation {
			origin.x: root.tickWidth / 2; origin.y: 0
			axis { x: 0; y: 0; z: 1 }
			angle: -root.minuteAngle
		}
		MouseArea {
			anchors.fill: parent
			anchors.leftMargin: -8
			anchors.rightMargin: -8
			cursorShape: Qt.PointingHandCursor
			onReleased: {
				minuteDragged = true
				minuteDragStartTime = Number(new Date())
				minuteDragAmplitude = minuteAngle - actualMinuteAngle
			}
			onPositionChanged: {
				const coord = mapToItem(root, mouseX, mouseY)
				const x = coord.x - radius
				const y = coord.y - radius
				const rawAngle = Math.atan2(-x, -y) * 180 / Math.PI
				const rawAngle2 = Math.floor(minuteAngle / 360 + 0.5) * 360 + rawAngle
				minuteAngle = rawAngle2 + 180 < minuteAngle ? rawAngle2 + 360 : rawAngle2
			}
		}
	}

	Rectangle {
		visible: secondHandVisible
		width: root.tickWidth
		height: root.tickHeight
		radius: tickRadius
		color: Config.colors.widget.accent
		x: root.radius + root.radius * Math.cos((-root.secondAngle - 90) * Math.PI / 180)
		y: root.radius + root.radius * Math.sin((-root.secondAngle - 90) * Math.PI / 180)
		transform: Rotation {
			origin.x: root.tickWidth / 2; origin.y: 0
			axis { x: 0; y: 0; z: 1 }
			angle: -root.secondAngle
		}
		MouseArea {
			anchors.fill: parent
			anchors.leftMargin: -8
			anchors.rightMargin: -8
			cursorShape: Qt.PointingHandCursor
			onReleased: {
				secondDragged = true
				secondDragStartTime = Number(new Date())
				secondDragAmplitude = secondAngle - actualSecondAngle
			}
			onPositionChanged: {
				const coord = mapToItem(root, mouseX, mouseY)
				const x = coord.x - radius
				const y = coord.y - radius
				const rawAngle = Math.atan2(-x, -y) * 180 / Math.PI
				const rawAngle2 = Math.floor(secondAngle / 360 + 0.5) * 360 + rawAngle
				secondAngle = rawAngle2 + 180 < secondAngle ? rawAngle2 + 360 : rawAngle2
			}
		}
	}

	Repeater {
		model: 12

		Rectangle {
			required property int modelData
			width: root.tickWidth
			height: root.tickHeight
			radius: tickRadius
			color: Config.colors.widget.bg
			x: root.radius + root.radius * Math.cos(modelData * 2 * Math.PI / 12)
			y: root.radius + root.radius * Math.sin(modelData * 2 * Math.PI / 12)
			transform: Rotation {
				origin.x: root.tickWidth / 2; origin.y: 0
				axis { x: 0; y: 0; z: 1 }
				angle: 90 + 360 * modelData / 12
			}
		}
	}
}
