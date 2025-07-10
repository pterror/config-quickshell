import QtQuick
import qs

FrameAnimation {
	running: true
	property real value: 0
	property real velocity: 0
	property real newVelocity: 0
	property real momentum: -1
	property real momentumUp: momentum !== -1 ? momentum : 0
	property real momentumDown: momentum !== -1 ? momentum : 0.2
	property int frameRate: Config._.frameRate
	property real momentumUpFrame: Math.pow(momentumUp, frameTime)
	property real momentumDownFrame: Math.pow(momentumDown, frameTime)
	property real epsilon: 0.01
	property var processValue: x => x

	function impulse(value) { newVelocity += value }

	onTriggered: {
		if (velocity === 0 && newVelocity === 0) {
			value = processValue(value, frameTime)
			return
		}
		if (Math.abs(newVelocity) < epsilon) newVelocity = 0
		if (Math.abs(velocity) < epsilon) velocity = 0
		velocity = Math.abs(newVelocity) > Math.abs(velocity)
			? velocity * momentumUpFrame + newVelocity * (1 - momentumUpFrame)
			: velocity * momentumDownFrame + newVelocity * (1 - momentumDownFrame)
		newVelocity = 0
		value = processValue(value + velocity, frameTime)
	}
}
