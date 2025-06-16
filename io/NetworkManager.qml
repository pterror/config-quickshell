pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import "root:/"

Singleton {
	property bool connected: ethernetConnected || wifiConnected
	property string network: ethernetNetwork || wifiNetwork
	property int strength: wifiStrength
	property string ethernetNetwork: ""
	property bool ethernetConnected: ethernetNetwork !== ""
	property string wifiNetwork: ""
	property bool wifiConnected: wifiNetwork !== ""
	property int wifiStrength: 0

	Process {
		running: true
		onRunningChanged: running = true
		command: ["nmcli", "m"]
		stdout: SplitParser {
			onRead: data => {
				if (Config._.debug) {
					console.log("NetworkManager [stdin]: " + data)
				}
				const a = []
				const [, interface_, event] = data.match(/(.+?): (.+?)/) ?? []
				if (!interface_) return
				switch (event) {
					case "disconnected": {
						if (interface_.startsWith("wlp") || interface_.startsWith("wlan")) {
							wifiConnected = false
							wifiNetwork = ""
						} else {
							ethernetConnected = false
							ethernetNetwork = ""
						}
						updateProcess.running = true
					}
					case "connected": {
						if (interface_.startsWith("wlp") || interface_.startsWith("wlan")) {
							wifiConnected = true
						} else {
							ethernetConnected = true
						}
						updateProcess.running = true
					}
				}
			}
		}
	}

	Process {
		id: updateProcess
		running: true
		command: ["nmcli", "device"]
		stdout: SplitParser {
			onRead: data => {
				if (Config._.debug) {
					console.log("NetworkManager [device:stdin]: " + data)
				}
				const [, _device, type, state, connection] = data.match(/^(.+?) +(.+?) +(.+?) +(.+?)$/) ?? []
				switch (type) {
					case "TYPE": { break }
					case "wifi": {
						wifiConnected = state === "connected"
						wifiNetwork = wifiConnected ? connection : ""
						break
					}
					case "ethernet": {
						ethernetConnected = state === "connected"
						ethernetNetwork = ethernetConnected ? connection : ""
					}
					default: { break }
				}
			}
		}
	}

	Process {
		id: listWifiProcess
		running: true
		command: ["nmcli", "device", "wifi", "list"]
		stdout: SplitParser {
			onRead: data => {
				if (Config._.debug) {
					console.log("NetworkManager [wifi-list:stdin]: " + data)
				}
				const [, inUse, _bssid, ssid, _mode, _chan, _rate, signal, _bars, _security] = data.match(/^([*])? +(.+?) +(.+?) +(.+?) +(.+?) +(.+?) Mbit[/]s +(.+?) +(.+?) +(.+?)$/) ?? []
				if (ssid === network) {
					network = ssid
					wifiStrength = Number(signal)
				}
			}
		}
	}
}
