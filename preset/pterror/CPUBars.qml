import QtQuick
import "root:/io"
import "root:/component"
import "root:/widget"
import "root:/"

InwardsRadialVisualizerBars {
	id: cpuViz
	input: CPUInfo
	innerRadius: 120; outerRadius: 220
	anchors.horizontalCenter: parent.horizontalCenter
	anchors.verticalCenter: parent.verticalCenter
	animationDuration: 1000; animationVelocity: 0.0001
	rotationOffset: cpuVizAnim.value

	MomentumAnimation {
		id: cpuVizAnim
		property real t: 0
		property int curveLength: Config._.frameRate * 1
		property real speedFromCpuUsage: (1 - CPUInfo.idleSec / CPUInfo.totalSec) / 0.1
		property list<real> opacityCurve: Array.from({ length: curveLength }, (_, i) => 0.8 + 0.2 * Math.sin(i * 2 * Math.PI / curveLength))
		property list<real> curve: Array.from({ length: curveLength }, (_, i) => -1 -.5 * Math.sin(i * 2 * Math.PI / curveLength))
		processValue: (x, frameTime) => {
			const frameDelta = frameTime * Config._.frameRate
			t = (t + frameDelta) % curveLength
			const frac = t % 1
			cpuViz.opacity = opacityCurve[Math.floor(t)] * frac + opacityCurve[Math.ceil(t) % curveLength] * (1 - frac)
			return (x + 360 + (curve[Math.floor(t)] * frac + curve[Math.ceil(t) % curveLength] * (1 - frac)) - speedFromCpuUsage * frameDelta) % 360
		}
	}

	MouseArea {
		id: cpuVizMouseArea
		x: cpuViz.width / 2 - cpuViz.outerRadius
		y: cpuViz.height / 2 - cpuViz.outerRadius
		width: cpuViz.outerRadius * 2
		height: cpuViz.outerRadius * 2
		property real startAngle: 0
		property real prevAngle: 0
		property real endAngle: 0
		onPressed: { updateAngle(true); cpuVizAnim.velocity = 0 }
		onReleased: {
			if (endAngle - startAngle > 180) startAngle += 360
			else if (startAngle - endAngle > 180) startAngle -= 360
			cpuVizAnim.impulse(endAngle - startAngle)
		}
		onPositionChanged: updateAngle()

		FrameAnimation { running: true; onTriggered: cpuVizMouseArea.startAngle = cpuVizMouseArea.endAngle }

		function updateAngle(initial) {
			const x = mouseX - cpuViz.outerRadius
			const y = mouseY - cpuViz.outerRadius
			endAngle = Math.atan2(-y, x) * 180 / Math.PI - 90
			if (initial) {
				startAngle = endAngle
				prevAngle = endAngle
			} else {
				cpuVizAnim.value += endAngle - prevAngle
				prevAngle = endAngle
			}
		}

		WheelHandler {
			acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
			onWheel: event => {
				cpuVizAnim.impulse((event.angleDelta.x + event.angleDelta.y) / 4)
			}
		}
	}
}