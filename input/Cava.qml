pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import ".."

Singleton {
	id: root
	property var subscribersByCount: ({})
	property list<var> counts: []
	signal value(int count, int index, int value)

	function updateCounts() {
		counts = Object.keys(subscribersByCount).map(s => Number(s) || 0)
	}

	function subscribe(count) {
		if (!(count in subscribersByCount)) { subscribersByCount[count] = 1 }
		else { subscribersByCount[count] += 1}
		updateCounts()
	}

	function unsubscribe(count) {
		if (!(count in subscribersByCount)) return
		const subscriberCount = subscribersByCount[count]
		if (subscriberCount === 1) { delete subscribersByCount[count] }
		else { subscribersByCount[count] -= 1}
		updateCounts()
	}

	Variants {
		model: counts

		Process {
			required property var modelData
			property int index: 0
			running: true
			onRunningChanged: running = true
			// FIXME: this is likely broken because stdin input comes in too late
			// command: ["cava", "-p", "/dev/stdin"]
			command: ["cava", "-p", "/dev/stdin"]
			onExited: { stdinEnabled = true; index = 0 }
			onStarted: {
				write(`\
[general]
bars=${modelData}
[smoothing]
ignore=1
[output]
method=raw
bit_format=8
\0`)
				stdinEnabled = false
			}
			stdout: SplitParser {
				splitMarker: ""
				onRead: data => {
					console.log(":0", data)
					for (let i = 0; i < data.length; i += 1) {
						root.value(modelData, index, c.charCodeAt())
						index += 1
						if (index === modelData) { index = 0 }
					}
				}
			}
			stderr: SplitParser {
				splitMarker: ""
				onRead: data => {
					console.error(":(", data)
				}
			}
		}
	}
}
