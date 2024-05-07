pragma Singleton

import Quickshell
import Quickshell.Hyprland
import ".."

Singleton {
	GlobalShortcut {
		name: "workspaces_overview:toggle"
		description: "open and close the workspaces overview"
		onPressed: Config.workspacesOverview.visible = !Config.workspacesOverview.visible
	}

	GlobalShortcut {
		name: "wlogout:toggle"
		description: "open and close the logout menu"
		onPressed: Config.wLogout.visible = !Config.wLogout.visible
	}
}
