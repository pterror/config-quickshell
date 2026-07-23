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

	readonly property string backend: Quickshell.env("HYPRLAND_INSTANCE_SIGNATURE")
		? "hyprland"
		: ((Quickshell.env("SWAYSOCK") || Quickshell.env("I3SOCK")) ? "i3" : "unknown")
	readonly property bool isHyprland: backend === "hyprland"
	readonly property bool isI3: backend === "i3"
	readonly property var backendHandle: isHyprland ? H.Hyprland : (isI3 ? I.I3 : null)

	readonly property var focusedMonitor: backendHandle?.focusedMonitor ?? null
	readonly property var focusedWorkspace: backendHandle?.focusedWorkspace ?? null
	readonly property var monitors: backendHandle?.monitors ?? null
	readonly property var workspaces: backendHandle?.workspaces ?? null
	readonly property var focusedScreen: Quickshell.screens.find(screen => screen.name === focusedMonitor?.name) ?? null

	readonly property var activeToplevel: isHyprland ? H.Hyprland.activeToplevel : ToplevelManager.activeToplevel
	readonly property var toplevels: isHyprland ? H.Hyprland.toplevels : ToplevelManager.toplevels
	readonly property var workspacesById: {
		const result = {}
		for (const workspace of workspaces?.values ?? [])
			result[workspace.id] = workspace
		return result
	}

	property string submap: ""
	property var overlayAddress: undefined
	property bool isOverlaid: false
	property string activeAddress: ""
	property string activeTitle: ""
	property string activeClass: ""

	property QtObject activeWindow: QtObject {
		property string address: root.activeAddress
		property string title: root.activeTitle
		property string klass: root.activeClass
	}

	property QtObject activeKeyboardLayout: QtObject {
		property string keyboard: "(unknown)"
		property string layout: "(unknown)"
	}

	signal configReloaded()
	signal rawEvent(var event)

	function normalizeAddress(address) {
		return String(address ?? "").replace(/^address:/, "").replace(/^0x/i, "")
	}

	function updateActiveWindowState() {
		activeAddress = normalizeAddress(activeToplevel?.address)
		activeTitle = activeToplevel?.title ?? ""
		activeClass = activeToplevel?.appId ?? ""
	}

	function focusWorkspace(name) {
		const requested = String(name)
		const workspace = workspaces?.values?.find(value =>
			value.name === requested || String(value.id) === requested || String(value.num ?? value.number ?? "") === requested
		) ?? null
		if (workspace?.activate) {
			workspace.activate()
			return
		}
		if (isHyprland)
			H.Hyprland.dispatch(`workspace ${requested}`)
		else if (isI3)
			I.I3.dispatch(`workspace ${requested}`)
	}

	function focusWorkspaceOnCurrentMonitor(id) {
		focusWorkspace(String(id))
	}

	Connections {
		target: isHyprland ? H.Hyprland : (isI3 ? I.I3 : null)
		function onRawEvent(event) {
			root.rawEvent(event)
		}
	}

	Connections {
		target: root.activeToplevel ?? null
		function onTitleChanged() { root.updateActiveWindowState() }
	}

	Component.onCompleted: {
		updateActiveWindowState()
	}
}
