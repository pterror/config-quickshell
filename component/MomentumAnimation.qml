import QtQuick
import ".."

FrameAnimation {
	running: true
	property real value: 0
	property real velocity: 0
	property real newVelocity: 0
	property real momentum: -1
	property real momentumUp: momentum !== -1 ? momentum : 0
	property real momentumDown: momentum !== -1 ? momentum : 0.2
	property int frameRate: Config.frameRate
	property real momentumUpFrame: Math.pow(momentumUp, 1 / frameRate)
	property real momentumDownFrame: Math.pow(momentumDown, 1 / frameRate)
	property real epsilon: 0.01
	property var processAngle: x => x

	function impulse(value) { newVelocity += value }

	onTriggered: {
		if (velocity === 0 && newVelocity === 0) return
		if (Math.abs(newVelocity) < epsilon) newVelocity = 0
		if (Math.abs(velocity) < epsilon) velocity = 0
		velocity = Math.abs(newVelocity) > Math.abs(velocity)
			? velocity * momentumUpFrame + newVelocity * (1 - momentumUpFrame)
			: velocity * momentumDownFrame + newVelocity * (1 - momentumDownFrame)
		newVelocity = 0
		value = processAngle(value + velocity)
	}
}