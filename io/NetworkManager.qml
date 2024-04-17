pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import ".."

Singleton {
	property string network: ""
	property int strength: 0
	property bool connected: true

	Process {
		running: true
		onRunningChanged: running = true
		command: ["nmcli", "m"]
		stdout: SplitParser {
			onRead: data => {
				if (Config.debug) {
					console.log("NetworkManager [stdin]: " + data)
				}
				const a = []
				const [, interface_, event] = data.match(/(.+?): (.+?)/) ?? []
				if (!interface_) return
				switch (event) {
					case "disconnected": {
						connected = false
						updateProcess.running = true
					}
					case "connected": {
						connected = true
						updateProcess.running = true
					}
				}
			}
		}
	}

	Process {
		id: updateProcess
		running: true
		command: ["nmcli", "device", "wifi", "list"]
		stdout: SplitParser {
			onRead: data => {
				if (Config.debug) {
					console.log("NetworkManager [wifi-list:stdin]: " + data)
				}
				const [, inUse, _bssid, ssid, _mode, _chan, _rate, signal, _bars, _security] = data.match(/^([*])? +(.+?) +(.+?) +(.+?) +(.+?) +(.+?) Mbit[/]s +(.+?) +(.+?) +(.+?)/) ?? []
				if (inUse !== "*") return
				network = ssid
				strength = Number(signal)
			}
		}
	}
}
