import QtQuick
import "root:/library"
import "root:/"

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
	property real actualMinuteAngle: -(Number(Time.rawTime) / 60000 % 60 * (360 / 60))
	property real actualHourAngle: -((Number(Time.rawTime) - Time.time.getTimezoneOffset() * 60000) / 3600000 % 24 * (360 / 12))
	property real secondAngle: actualSecondAngle
	property real minuteAngle: actualMinuteAngle
	property real hourAngle: actualHourAngle
	property real minAmplitude: 0.1
	property real dragDuration: 4 // in seconds
	property bool setTimeDelta: true
	property bool hourDragged: false
	property real hourDragAmplitude: 0
	property real hourDragAngle: 0
	property real hourDragStartTime: 0
	property real hourDragDecaySec: 0
	property bool minuteDragged: false
	property real minuteDragAmplitude: 0
	property real minuteDragAngle: 0
	property real minuteDragStartTime: 0
	property real minuteDragDecaySec: 0
	property bool secondDragged: false
	property real secondDragAmplitude: 0
	property real secondDragAngle: 0
	property real secondDragStartTime: 0
	property real secondDragDecaySec: 0
	implicitWidth: radius * 2
	implicitHeight: radius * 2
	color: "transparent"

	onSetTimeDeltaChanged: {
		if (setTimeDelta) return
		Time.timeDelta = 0
	}

	FrameAnimation {
		running: secondHandVisible || hourDragged || minuteDraged || secondDragged
		onTriggered: {
			actualSecondAngle = -(Number(new Date()) / 1000 % 60 * (360 / 60))
			if (hourDragged) {
				hourDragAmplitude *= Math.pow(hourDragDecaySec, frameTime)
				const deltaTime = (new Date() - hourDragStartTime) / 1000
				const delta = hourDragAmplitude * Math.cos(deltaTime * 2 * Math.PI)
				hourAngle = actualHourAngle + delta
				if (Math.abs(hourDragAmplitude) < minAmplitude) {
					hourAngle = Qt.binding(() => actualHourAngle)
					hourDragged = false
				}
			}
			if (minuteDragged) {
				minuteDragAmplitude *= Math.pow(minuteDragDecaySec, frameTime)
				const deltaTime = (new Date() - minuteDragStartTime) / 1000
				const delta = minuteDragAmplitude * Math.cos(deltaTime * 2 * Math.PI)
				minuteAngle = actualMinuteAngle + delta
				if (Math.abs(minuteDragAmplitude) < minAmplitude) {
					minuteAngle = Qt.binding(() => actualMinuteAngle)
					minuteDragged = false
				}
			}
			if (secondDragged) {
				secondDragAmplitude *= Math.pow(secondDragDecaySec, frameTime)
				const deltaTime = (new Date() - secondDragStartTime) / 1000
				const delta = secondDragAmplitude * Math.cos(deltaTime * 2 * Math.PI)
				secondAngle = actualSecondAngle + delta
				if (Math.abs(secondDragAmplitude) < minAmplitude) {
					secondAngle = Qt.binding(() => actualSecondAngle)
					secondDragged = false
				}
			}
			if (setTimeDelta && (
				secondAngle !== actualSecondAngle ||
				minuteAngle !== actualMinuteAngle ||
				hourAngle !== actualHourAngle
			)) {
				Time.timeDelta =
					(actualHourAngle - hourAngle) / 30 /* 1 / 30 = 12 / 360 */ * 3600000 +
					(actualMinuteAngle - minuteAngle) / 6 /* 1 / 6 = 60 / 360 */ * 60000 +
					(actualSecondAngle - secondAngle) / 6 /* 1 / 6 = 60 / 360 */ * 1000
			}
		}
	}

	MouseArea {
		property string draggingHand: ""
		anchors.fill: parent
		onPressed: {
			const x = mouseX - radius
			const y = mouseY - radius
			const r2 = x * x + y * y
			if (r2 > radius * radius) {} // ignore
			else if (r2 > (radius - tickHeight) ** 2) { draggingHand = "second" }
			else if (r2 > (radius - tickHeight * 2) ** 2) { draggingHand = "minute" }
			else if (r2 > (radius - tickHeight * 3) ** 2) { draggingHand = "hour" }
		}
		onPositionChanged: {
			if (draggingHand === "") { return }
			const coord = Qt.point(mouseX, mouseY)
			switch (draggingHand) {
				case "hour": { updateHourDrag(coord); break }
				case "minute": { updateMinuteDrag(coord); break }
				case "second": { updateSecondDrag(coord); break }
			}
		}
		onReleased: {
			switch (draggingHand) {
				case "hour": { startHourSpring(); break }
				case "minute": { startMinuteSpring(); break }
				case "second": { startSecondSpring(); break }
			}
			draggingHand = ""
		}
	}

	Rectangle {
		visible: hourHandVisible
		width: root.tickWidth
		height: root.tickHeight
		radius: tickRadius
		property int innerRadius: root.radius - tickHeight * 2
		color: Config._.style.widget.accent
		x: root.radius + innerRadius * Math.cos((-root.hourAngle - 90) * Math.PI / 180)
		y: root.radius + innerRadius * Math.sin((-root.hourAngle - 90) * Math.PI / 180)
		transform: Rotation {
			origin.x: root.tickWidth / 2; origin.y: 0; axis { x: 0; y: 0; z: 1 }
			angle: -root.hourAngle
		}
		MouseArea {
			anchors.fill: parent
			anchors.leftMargin: -8
			anchors.rightMargin: -8
			cursorShape: Qt.PointingHandCursor
			onReleased: startHourSpring()
			onPositionChanged: updateHourDrag(mapToItem(root, mouseX, mouseY))
		}
	}

	function startHourSpring() {
		if (hourAngle === actualHourAngle) return
		hourDragged = true
		hourDragStartTime = Number(new Date())
		hourDragAmplitude = hourAngle - actualHourAngle
		hourDragDecaySec =
			Math.pow(Math.abs(minAmplitude / hourDragAmplitude), 1 / dragDuration) || 0
	}

	function updateHourDrag(coord) {
		hourDragged = false
		const x = coord.x - radius
		const y = coord.y - radius
		const rawAngle = Math.atan2(-x, -y) * 180 / Math.PI
		const rawAngle2 = Math.floor(hourAngle / 360 + 0.5) * 360 + rawAngle
		hourAngle = rawAngle2 + 180 < hourAngle ? rawAngle2 + 360
			: rawAngle2 - 180 > hourAngle ? rawAngle2 - 360
			: rawAngle2
	}

	Rectangle {
		visible: minuteHandVisible
		width: root.tickWidth
		height: root.tickHeight
		radius: tickRadius
		property int innerRadius: root.radius - tickHeight
		color: Config._.style.widget.accent
		x: root.radius + innerRadius * Math.cos((-root.minuteAngle - 90) * Math.PI / 180)
		y: root.radius + innerRadius * Math.sin((-root.minuteAngle - 90) * Math.PI / 180)
		transform: Rotation {
			origin.x: root.tickWidth / 2; origin.y: 0; axis { x: 0; y: 0; z: 1 }
			angle: -root.minuteAngle
		}
		MouseArea {
			anchors.fill: parent
			anchors.leftMargin: -8
			anchors.rightMargin: -8
			cursorShape: Qt.PointingHandCursor
			onReleased: startMinuteSpring()
			onPositionChanged: updateMinuteDrag(mapToItem(root, mouseX, mouseY))
		}
	}

	function startMinuteSpring() {
		if (minuteAngle === actualMinuteAngle) return
		minuteDragged = true
		minuteDragStartTime = Number(new Date())
		minuteDragAmplitude = minuteAngle - actualMinuteAngle
		minuteDragDecaySec =
			Math.pow(Math.abs(minAmplitude / minuteDragAmplitude), 1 / dragDuration)
	}

	function updateMinuteDrag(coord) {
		minuteDragged = false
		const x = coord.x - radius
		const y = coord.y - radius
		const rawAngle = Math.atan2(-x, -y) * 180 / Math.PI
		const rawAngle2 = Math.floor(minuteAngle / 360 + 0.5) * 360 + rawAngle
		minuteAngle = rawAngle2 + 180 < minuteAngle ? rawAngle2 + 360
			: rawAngle2 - 180 > minuteAngle ? rawAngle2 - 360
			: rawAngle2
	}

	Rectangle {
		visible: secondHandVisible
		width: root.tickWidth
		height: root.tickHeight
		radius: tickRadius
		color: Config._.style.widget.accent
		x: root.radius + root.radius * Math.cos((-root.secondAngle - 90) * Math.PI / 180)
		y: root.radius + root.radius * Math.sin((-root.secondAngle - 90) * Math.PI / 180)
		transform: Rotation {
			origin.x: root.tickWidth / 2; origin.y: 0; axis { x: 0; y: 0; z: 1 }
			angle: -root.secondAngle
		}
		MouseArea {
			anchors.fill: parent
			anchors.leftMargin: -8
			anchors.rightMargin: -8
			cursorShape: Qt.PointingHandCursor
			onReleased: startSecondSpring()
			onPositionChanged: updateSecondDrag(mapToItem(root, mouseX, mouseY))
		}
	}

	function startSecondSpring() {
		if (secondAngle === actualSecondAngle) return
		secondDragged = true
		secondDragStartTime = Number(new Date())
		secondDragAmplitude = secondAngle - actualSecondAngle
		secondDragDecaySec =
			Math.pow(Math.abs(minAmplitude / secondDragAmplitude), 1 / dragDuration) || 0
	}

	function updateSecondDrag(coord) {
		secondDragged = false
		const x = coord.x - radius
		const y = coord.y - radius
		const rawAngle = Math.atan2(-x, -y) * 180 / Math.PI
		const rawAngle2 = Math.floor(secondAngle / 360 + 0.5) * 360 + rawAngle
		secondAngle = rawAngle2 + 180 < secondAngle ? rawAngle2 + 360
			: rawAngle2 - 180 > secondAngle ? rawAngle2 - 360
			: rawAngle2
	}

	Repeater {
		model: 12

		Rectangle {
			required property int modelData
			width: root.tickWidth
			height: root.tickHeight
			radius: tickRadius
			color: Config._.style.widget.bg
			x: root.radius + root.radius * Math.cos(modelData * 2 * Math.PI / 12)
			y: root.radius + root.radius * Math.sin(modelData * 2 * Math.PI / 12)
			transform: Rotation {
				origin.x: root.tickWidth / 2; origin.y: 0; axis { x: 0; y: 0; z: 1 }
				angle: 90 + 360 * modelData / 12
			}
		}
	}
}
