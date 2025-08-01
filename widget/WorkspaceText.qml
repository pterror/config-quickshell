import QtQuick
import QtQuick.Layouts
import qs
import qs.component

Text {
  property color focusedColor: Config._.style.accentFg
  property color activeColor: Config._.style.primaryFg
  property color emptyColor: Config._.style.secondaryFg

  Layout.minimumWidth: 13
  visible: !Config.isSpecialWorkspace(modelData?.name)
  text: modelData?.name ?? String(modelData + 1)
  color: modelData?.focused ? focusedColor : modelData?.active ? activeColor : emptyColor
}
