import QtQuick
import qs.io
import qs.component
import qs

StackedInwardsRadialVisualizerBars {
	id: cpuViz
	outerRadius: 220
	innerRadius: 120
	values: [CPUInfo.values, CPUInfo.iowaitValues]
	colors: [Config._.style.visualizer.barsBg, Config._.style.cpu.iowaitFg]
	driftSpeed: (1 - CPUInfo.idleSec / CPUInfo.totalSec) / 0.1
	anchors.horizontalCenter: parent.horizontalCenter
	anchors.verticalCenter: parent.verticalCenter
}
