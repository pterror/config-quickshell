import QtQuick
import Quickshell

ScriptModel {
  id: root
  required property int count
  values: Array.from({ length: count }, (_, i) => wrapper.createObject(root, { workspaceId: i + 1 }))
  property Component wrapper: HyprlandWorkspaceWrapper {}
}
