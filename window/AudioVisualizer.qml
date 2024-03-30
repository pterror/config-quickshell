import QtQuick
import Quickshell
import Quickshell.Wayland
import "../component"
import "../input"

PanelWindow {
	id: root
	color: "transparent"
	WlrLayershell.namespace: "shell:audio_visualizer"
	property int bars: 32
	property list<int> range: Array.from({ length: bars }, (_, i) => i)
	width: Math.max(content.implicitWidth, 1000)
	height: Math.max(content.implicitHeight, 1000)
	
	onVisibleChanged: {
		if (visible) {
			Cava.subscribe(bars)
		} else {
			// FIXME: this does not work if `bars` is changed.
			Cava.unsubscribe(bars)
		}
	}

	RowLayout2 {
		id: content
		autoSize: true

		Repeater {
			model: range

			Rectangle {
				required property int modelData
				property int value: 0
				color: "white"

				height: value
				width: 32

				Connections {
					target: Cava
					function onValue(count, index, newValue) {
						if (bars !== count || index !== modelData) return
						value = newValue
					}
				}
			}
		}
	}
}