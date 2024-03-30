pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import ".."

Singleton {
	property string network: ""
	property string networkId: ""
	property var strengths: ({})

	Process {
		running: true
		onRunningChanged: running = true
		command: ["connmanctl", "monitor", "--services"]
		stdout: SplitParser {
			onRead: data => {
				if (Config.debug) {
					console.log("Connman [stdin]: " + data)
				}
				const [, _type, network, key, value] = data.match(/(.+?) +(.+?) +(.+?) += +(.+)/) ?? []
				if (!network) return
				switch (key) {
					// Service events:
					// State: association | configuration | ready | online | disconnect | idle
					// Strength: 0-100
					// Domains: [  ]
					// Timeservers: [  ]
					// Nameservers: [ <string>* ]
					// Domains: [  ]
					// Proxy: [  ]
					// Ethernet = [ Method=<dhcp|auto>, Interface=<wlan0>, Address=<FF:FF:FF:FF:FF:FF>, MTU=<1500> ]
					// IPv4: [ Method=<dhcp|auto>, Address=<192.168.0.1>, Netmask=<255.255.255.0> ]
					// IPv6: [ Method=<dhcp|auto>, Address=<ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff>, PrefixLength=<64>, Privacy=<disabled> ]
					case "State": {
						switch (value) {
							case "online": {
								networkId = network
								updateNameProcess.running = true
								break
							}
							case "disconnect": { networkId = ""; break }
						}
						break
					}
					case "Strength": {
						strengths[network] = Number(value)
						break
					}
				}
			}
		}
	}

	Process {
		id: updateNameProcess
		running: true
		command: ["connmanctl", "services"]
		stdout: SplitParser {
			splitMarker: ""
			onRead: data => {
				const match = data.match(/^\*A[OR] (\S+)/m)
				if (match?.[1]) {
					network = match[1]
				}
			}
		}
	}
}
