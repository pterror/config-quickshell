pragma Singleton

import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland as H
import Quickshell.I3 as I
import QtQuick
import qs

Singleton {
	id: root

	property list<var> clientsData: []
	property var clientsByAddress: ({})

	function normalizeAddress(address) {
		return Compositor.normalizeAddress(address)
	}

	function matchToplevel(address, title, klass) {
		const normalized = normalizeAddress(address)
		for (const toplevel of Compositor.toplevels?.values ?? []) {
			if (normalizeAddress(toplevel?.address) === normalized)
				return toplevel?.wayland ?? toplevel
			if (toplevel?.title === title && (!klass || toplevel?.appId === klass))
				return toplevel
		}
		return null
	}

	function setClients(clients) {
		const map = {}
		for (const client of clients)
			map[normalizeAddress(client.address)] = client
		clientsByAddress = map
		clientsData = clients
		Compositor.updateActiveWindowState()
	}

	function refetchClients() {
		if (Compositor.isHyprland)
			hyprClientsProcess.running = true
		else if (Compositor.isI3)
			i3TreeProcess.running = true
	}

	function focusWindow(target) {
		const key = normalizeAddress(target)
		const client = clientsByAddress[key] ?? null
		if (client?.toplevel?.activate) {
			client.toplevel.activate()
			return
		}
		if (Compositor.isHyprland) {
			H.Hyprland.dispatch(`focuswindow ${String(target).startsWith("address:") ? target : `address:${key}`}`)
		} else if (Compositor.isI3 && key) {
			I.I3.dispatch(`[con_id=${key}] focus`)
		}
	}

	function parseHyprClients(text) {
		const data = JSON.parse(text)
		const clients = data.map(client => {
			const address = normalizeAddress(client.address)
			return {
				id: address,
				address,
				at: client.at,
				size: client.size,
				class: client.class,
				title: client.title,
				initialTitle: client.initialTitle ?? client.title,
				workspace: {
					id: client.workspace.id,
					name: client.workspace.name,
				},
				toplevel: matchToplevel(address, client.title, client.class),
			}
		})
		setClients(clients)
	}

	function parseI3Tree(text) {
		const tree = JSON.parse(text)
		const clients = []

		function visit(node, outputName, workspaceInfo) {
			if (!node)
				return

			let nextOutput = outputName
			let nextWorkspace = workspaceInfo

			if (node.type === "output" && node.name && !String(node.name).startsWith("__"))
				nextOutput = node.name

			if (node.type === "workspace") {
				nextWorkspace = {
					id: node.id,
					name: node.name,
					number: node.num,
				}
			}

			const rect = node.rect ?? {}
			const appId = node.app_id ?? node.window_properties?.class ?? ""
			const title = node.name ?? ""

			if (nextWorkspace && node.pid && (title || appId)) {
				clients.push({
					id: String(node.id),
					address: String(node.id),
					at: [rect.x ?? 0, rect.y ?? 0],
					size: [rect.width ?? 0, rect.height ?? 0],
					class: appId,
					title,
					initialTitle: title,
					workspace: nextWorkspace,
					output: nextOutput,
					toplevel: matchToplevel(String(node.id), title, appId),
				})
			}

			for (const child of node.nodes ?? [])
				visit(child, nextOutput, nextWorkspace)
			for (const child of node.floating_nodes ?? [])
				visit(child, nextOutput, nextWorkspace)
		}

		visit(tree, null, null)
		setClients(clients)
	}

	function recomputeHyprlandWorkspaces(includeSpecial = false) {
		const result = Array.from({ length: Config._.workspaceCount }, (_, i) => ({
			id: i,
			x: 0,
			y: 0,
			width: 1920,
			height: 1080,
			clients: [],
			special: false,
		}))
		const byId = {}
		for (const entry of result)
			byId[entry.id] = entry

		const specialResult = []
		for (const workspace of Compositor.workspaces?.values ?? []) {
			const isSpecial = Config.isSpecialWorkspace(workspace.name)
			if (isSpecial) {
				if (!includeSpecial)
					continue
			} else if (!/^\d+$/.test(workspace.name)) {
				continue
			}

			const screen = Quickshell.screens.find(value => value.name === workspace.monitor?.name)
			const entry = {
				id: workspace.id,
				name: workspace.name,
				x: screen?.x ?? 0,
				y: screen?.y ?? 0,
				width: screen?.width ?? 1920,
				height: screen?.height ?? 1080,
				clients: [],
				special: isSpecial,
			}

			if (isSpecial)
				specialResult.push(entry)
			else
				result[workspace.id - 1] = entry

			byId[workspace.id] = entry
		}

		specialResult.sort((a, b) => a.id - b.id)

		for (const client of clientsData) {
			const boundingBox = byId[client.workspace.id]
			if (!boundingBox)
				continue
			boundingBox.clients.push({
				address: client.address,
				x: client.at[0] - boundingBox.x,
				y: client.at[1] - boundingBox.y,
				width: client.size[0],
				height: client.size[1],
				class: client.class,
				title: client.title,
				toplevel: client.toplevel,
			})
		}

		return includeSpecial ? result.concat(specialResult) : result
	}

	function recomputeI3Workspaces() {
		const result = []
		const byKey = {}

		for (const workspace of Compositor.workspaces?.values ?? []) {
			const screen = Quickshell.screens.find(value => value.name === workspace.monitor?.name)
			const sortKey = workspace.number ?? workspace.num ?? Number.MAX_SAFE_INTEGER
			const entry = {
				id: workspace.id,
				name: workspace.name,
				number: workspace.number ?? workspace.num ?? sortKey,
				x: screen?.x ?? 0,
				y: screen?.y ?? 0,
				width: screen?.width ?? 1920,
				height: screen?.height ?? 1080,
				clients: [],
				special: false,
			}
			result.push(entry)
			byKey[String(workspace.id)] = entry
			byKey[workspace.name] = entry
			byKey[String(entry.number)] = entry
		}

		result.sort((a, b) => a.number - b.number)

		for (const client of clientsData) {
			const boundingBox = byKey[String(client.workspace.id)] ?? byKey[client.workspace.name]
			if (!boundingBox)
				continue
			boundingBox.clients.push({
				address: client.address,
				x: client.at[0] - boundingBox.x,
				y: client.at[1] - boundingBox.y,
				width: client.size[0],
				height: client.size[1],
				class: client.class,
				title: client.title,
				toplevel: client.toplevel,
			})
		}

		return result
	}

	function recomputeWorkspaces(includeSpecial = false) {
		return Compositor.isHyprland ? recomputeHyprlandWorkspaces(includeSpecial) : recomputeI3Workspaces()
	}

	Process {
		id: hyprClientsProcess
		command: ["hyprctl", "-j", "clients"]
		stdout: SplitParser {
			splitMarker: ""
			onRead: data => {
				try {
					root.parseHyprClients(String(data))
				} catch (error) {
					console.warn("[WindowIndex] failed to parse hyprctl clients:", error)
				}
			}
		}
	}

	Process {
		id: i3TreeProcess
		command: [Quickshell.env("SWAYSOCK") ? "swaymsg" : "i3-msg", "-t", "get_tree"]
		stdout: SplitParser {
			splitMarker: ""
			onRead: data => {
				try {
					root.parseI3Tree(String(data))
				} catch (error) {
					console.warn("[WindowIndex] failed to parse i3 tree:", error)
				}
			}
		}
	}

	Component.onCompleted: refetchClients()
}
