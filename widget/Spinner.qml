import QtQuick
import QtMultimedia
import ".."

Rectangle {
	id: root
	property int radius: 128
	property int ticks: 12
	property int tickHeight: 24
	property int tickWidth: 6
	property int tickRadius: 2
	property real angle: 0
	property real velocity: 0
	property real newVelocity: 0
	property real degreesPerTick: 360 / ticks
	property real momentum: -1
	property real momentumUp: momentum !== -1 ? momentum : 0
	property real momentumDown: momentum !== -1 ? momentum : 0.2
	property int frameRate: 60
	property real momentumUpFrame: Math.pow(momentumUp, 1 / frameRate)
	property real momentumDownFrame: Math.pow(momentumDown, 1 / frameRate)
	property real epsilon: 0.01
	implicitWidth: radius * 2
	implicitHeight: radius * 2
	color: "transparent"

	FrameAnimation {
		running: true
		onTriggered: {
			if (velocity === 0 && newVelocity === 0) return
			if (Math.abs(newVelocity) < epsilon) newVelocity = 0
			if (Math.abs(velocity) < epsilon) velocity = 0
			if (velocity === 0 && newVelocity === 0) return
			velocity = Math.abs(newVelocity) > Math.abs(velocity)
				? velocity * momentumUpFrame + newVelocity * (1 - momentumUpFrame)
				: velocity * momentumDownFrame + newVelocity * (1 - momentumDownFrame)
			newVelocity = 0
			const newAngle = angle + velocity
			if (Math.floor(newAngle / degreesPerTick) !== Math.floor(angle / degreesPerTick)) {
				if (!click.playing) {
					click.loops = 1
					click.play()
				} else {
					click.loops = click.loopsRemaining
				}
			}
			// modulo 100 revolutions because overflow breaks SmoothedAnimation
			angle = (newAngle + 360) % 360
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
			origin.x: 0
			origin.y: 0
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

	function spin(angleDelta) {
		newVelocity += angleDelta
	}
}
