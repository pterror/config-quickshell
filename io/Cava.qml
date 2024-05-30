import QtQuick
import Quickshell
import Quickshell.Io
import ".."

Scope {
	id: root
	property int count: 32
	property int noiseReduction: 70
	property string channels: "mono" // or stereo
	property string monoOption: "average" // or left or right
	property var config: ({
		general: { bars: count },
		smoothing: { noise_reduction: noiseReduction },
		output: {
			method: "raw",
			bit_format: 8,
			channels: channels,
			mono_option: monoOption,
		}
	})
	property list<real> values: Array(count).fill(0) // 0 <= value <= 1

	onConfigChanged: {
		process.running = false
		process.running = true
	}

	Process {
		property int index: 0
		id: process
		stdinEnabled: true
		command: ["cava", "-p", "/dev/stdin"]
		onExited: { stdinEnabled = true; index = 0 }
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
				const newValues = [...values] // duplicate and set once to avoid spamming signals
				if (process.index + data.length > config.general.bars) {
					process.index = 0
				}
				for (let i = 0; i < data.length; i += 1) {
					newValues[i + process.index] = Math.min(data.charCodeAt(i), 128) / 128
				}
				process.index += data.length
				values = newValues
			}
		}
	}
}
