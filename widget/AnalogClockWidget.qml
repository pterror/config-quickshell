import QtQuick
import "../library"
import ".."

Rectangle {
	id: root
	property int radius: 128
	property int tickHeight: 24
	property int tickWidth: 6
	property int tickRadius: 2
	property real secondAngle: -(Number(new Date()) / 1000 % 60 * (360 / 60))
	property real minuteAngle: -(Number(Time.time) / 60000 % 60 * (360 / 60))
	property real hourAngle: -((Number(Time.time) - Time.time.getTimezoneOffset() * 60000) / 3600000 % 24 * (360 / 12))
	implicitWidth: radius * 2
	implicitHeight: radius * 2
	color: "transparent"

	FrameAnimation {
		running: true
		onTriggered: secondAngle = -(Number(new Date()) / 1000 % 60 * (360 / 60))
	}

	Rectangle {
		required property int modelData
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
	}

	Rectangle {
		required property int modelData
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
	}

	Rectangle {
		required property int modelData
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
