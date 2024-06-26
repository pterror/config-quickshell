import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import "root:/component"
import "root:/io"
import "root:/"

PanelWindow {
	id: root
	color: "transparent"
	mask: Region {}
	WlrLayershell.namespace: "shell:cpu_info_grid"
	exclusiveZone: 0
	Component.onCompleted: {
		if (this.WlrLayershell) this.WlrLayershell.layer = WlrLayer.Bottom
	}

	GridLayout {
		columns: 4
		rows: Math.ceil(CPUInfo.cpuInfos.length / 4)
		anchors.fill: parent

		Repeater {
			model: CPUInfo.cpuCount

			VProgressBar {
				required property var modelData
				id: progressBar
				Layout.fillHeight: true
				Layout.fillWidth: true
				animationDuration: CPUInfo.interval
				animationSpeed: -1
				fraction: 0
				radius: 0
				margins: 0
				innerRadius: Config.layout.rectangle.radius
				color: "transparent"
				fg: Config.colors.rectangle.bg

				Connections {
					target: CPUInfo
					function onCpuFractionSec(cpu, fraction) {
						if (cpu !== modelData) return
						progressBar.fraction = progressBar.fraction * 0.2 + fraction * 0.8
					}
				}
			}
		}
	}
}
