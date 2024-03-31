import QtQuick
import Quickshell
import Quickshell.Io
import ".."

QtObject {
	id: root
	property var config: ({
		general: { bars: 32 },
		smoothing: { noise_reduction: 60 },
		output: {
			method: "raw",
			bit_format: 8,
			channels: "mono",
			mono_option: "right",
		}
	})
	property int count: root.config.general.bars || 0
	signal value(int index, int value)

	property var process: Process {
		id: process
		running: true
		stdinEnabled: true
		// onRunningChanged: running = true
		command: ["cava", "-p", "/dev/stdin"]
		onExited: {
			stdinEnabled = true; index = 0
			console.log("......")
		}
		onStarted: {
			const iniParts = []
			for (const k in config) {
				if (typeof config[k] !== "object") {
					write(k + "=" + config[k] + "\n")
					continue
				}
				write("[" + k + "]\n")
				const obj = config[k]
				for (const k2 in obj) {
					write(k2 + "=" + obj[k2] + "\n")
				}
			}
			stdinEnabled = false
		}
		stdout: SplitParser {
			splitMarker: ""
			onRead: data => {
				for (let i = 0; i < data.length; i += 1) {
					root.value(i, Math.min(data.charCodeAt(i), 128))
				}
			}
		}
	}
}
