import QtQuick
import qs
import qs.component

Rectangle {
  property int size: 12
  property color focusedColor: Config._.style.accentFg
  property color activeColor: Config._.style.primaryFg
  property color emptyColor: Config._.style.secondaryFg
  implicitWidth: size
  implicitHeight: size
  radius: size / 2

  visible: !Config.isSpecialWorkspace(modelData?.name)
  color: modelData?.focused ? focusedColor : modelData?.active ? activeColor : emptyColor
}
