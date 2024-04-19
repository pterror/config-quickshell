import QtQuick
import QtMultimedia
import ".."

Rectangle {
	id: root
	property int radius: 128
	property int ticks: 12
	property int tickHeight: 24
	property int tickWidth: 6
	property real angle: 0
	property real smoothedAngle: angle
	property bool clickQueued: false
	property real degreesPerTick: 360 / ticks
	implicitWidth: radius * 2
	implicitHeight: radius * 2
	color: "transparent"

	Behavior on smoothedAngle { SmoothedAnimation { duration: 25 } }

	Rectangle {
		required property int modelData
		width: root.tickWidth
		height: root.tickHeight
		radius: 2
		color: Config.colors.widget.accent
		x: root.radius + root.radius * Math.cos((-root.smoothedAngle - 90) * Math.PI / 180)
		y: root.radius + root.radius * Math.sin((-root.smoothedAngle - 90) * Math.PI / 180)
		transform: Rotation {
			origin.x: 0
			origin.y: 0
			axis { x: 0; y: 0; z: 1 }
			angle: -root.smoothedAngle
		}
	}

	Repeater {
		model: ticks

		Rectangle {
			required property int modelData
			width: root.tickWidth
			height: root.tickHeight
			radius: 2
			color: Config.colors.widget.bg
			x: root.radius + root.radius * Math.cos(modelData * 2 * Math.PI / root.ticks)
			y: root.radius + root.radius * Math.sin(modelData * 2 * Math.PI / root.ticks)
			transform: Rotation {
				origin.x: 0
				origin.y: 0
				axis { x: 0; y: 0; z: 1 }
				angle: 90 + 360 * modelData / root.ticks
			}
		}
	}

	SoundEffect {
		id: click
		source: "../sound/click.wav"
		onLoopsRemainingChanged: {
			unstuck.restart()
		}
	}

	function spin(angleDelta) {
		const newAngle = angle + angleDelta
		if (Math.floor(newAngle / degreesPerTick) !== Math.floor(angle / degreesPerTick)) {
			if (!click.playing) {
				click.loops = 1
				click.play()
			} else {
				click.loops = click.loopsRemaining
			}
		}
		// modulo 100 revolutions because overflow breaks SmoothedAnimation
		angle = (newAngle + 18000) % 36000 - 18000
	}

	// FIXME: required to work around a QML bug where `playing`` occasionally stays stuck at `true`
	// with constantly increasing loop count
	Timer { id: unstuck; interval: 100; onTriggered: click.loopsRemaining != 0 && click.play() }
}
