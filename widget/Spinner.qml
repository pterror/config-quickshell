import QtQuick
import QtMultimedia
import "../component"
import ".."

Rectangle {
	id: root
	property bool muted: false
	property int radius: 128
	property int ticks: 12
	property int tickHeight: 24
	property int tickWidth: 6
	property int tickRadius: 2
	property real angle: animation.value
	property real oldAngle: 0
	property real degreesPerTick: 360 / ticks
	property var animation: MomentumAnimation {
		processAngle: x => (x + 360) % 360
	}
	implicitWidth: radius * 2
	implicitHeight: radius * 2
	color: "transparent"

	function spin(angleDelta) { animation.impulse(angleDelta) }

	onAngleChanged: {
		if (Math.floor(angle / degreesPerTick) !== Math.floor(oldAngle / degreesPerTick)) {
			playClick()
		}
		oldAngle = angle
	}

	function playClick() {
		if (muted) return
		if (!click.playing) {
			click.loops = 1
			click.play()
		} else {
			click.loops = click.loopsRemaining
		}
	}

	Rectangle {
		required property int modelData
		width: root.tickWidth
		height: root.tickHeight
		radius: tickRadius
		color: Config.colors.widget.accent
		x: root.radius + root.radius * Math.cos((-root.angle - 90) * Math.PI / 180)
		y: root.radius + root.radius * Math.sin((-root.angle - 90) * Math.PI / 180)
		transform: Rotation {
			origin.x: root.tickWidth / 2; origin.y: 0
			axis { x: 0; y: 0; z: 1 }
			angle: -root.angle
		}
	}

	Repeater {
		model: ticks

		Rectangle {
			required property int modelData
			width: root.tickWidth
			height: root.tickHeight
			radius: tickRadius
			color: Config.colors.widget.bg
			x: root.radius + root.radius * Math.cos(modelData * 2 * Math.PI / root.ticks)
			y: root.radius + root.radius * Math.sin(modelData * 2 * Math.PI / root.ticks)
			transform: Rotation {
				origin.x: root.tickWidth / 2; origin.y: 0
				axis { x: 0; y: 0; z: 1 }
				angle: 90 + 360 * modelData / root.ticks
			}
		}
	}

	SoundEffect { id: click; source: "../sound/click.wav" }

	MouseArea {
		anchors.fill: parent
		property real startAngle: 0
		property real endAngle: 0
		onPressed: { updateAngle(true); animation.velocity = 0 }
		onReleased: {
			if (endAngle - startAngle > 180) startAngle += 360
			else if (startAngle - endAngle > 180) startAngle -= 360
			animation.impulse(endAngle - startAngle)
		}
		onPositionChanged: updateAngle()

		FrameAnimation { running: true; onTriggered: parent.startAngle = parent.endAngle }

		function updateAngle(initial) {
			const x = mouseX - radius
			const y = mouseY - radius
			endAngle = Math.atan2(-y, x) * 180 / Math.PI - 90
			if (initial) startAngle = endAngle
			animation.value = endAngle
		}
	}
}
