import QtQuick
import Quickshell.Hyprland as Q

QtObject {
  required property int workspaceId
  property Q.HyprlandWorkspace workspace: Hyprland.workspacesById[workspaceId] ?? null
  property bool hasFullscreen: workspace?.hasFullscreen ?? false
  property Q.HyprlandMonitor monitor: workspace?.monitor ?? Hyprland.focusedMonitor
  property bool name: workspace?.name ?? String(workspaceId + 1)
  property bool active: workspace?.active ?? false
  property bool focused: workspace?.focused ?? false
  function activate() {
    if (workspace) {
      workspace.activate();
      return;
    }
    focusWorkspaceOnCurrentMonitor(workspaceId);
  }
}
