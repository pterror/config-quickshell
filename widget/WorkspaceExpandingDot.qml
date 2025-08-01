import QtQuick
import qs
import qs.component

Rectangle {
  property int size: 12
  property int focusedWidth: size * 2 + 8
  property real animationVelocity: -1
  property int animationDuration: 150
  property color focusedColor: Config._.style.accentFg
  property color activeColor: Config._.style.primaryFg
  property color emptyColor: Config._.style.secondaryFg
  implicitWidth: modelData?.focused ? focusedWidth : size
  implicitHeight: size
  radius: size / 2
	Behavior on implicitWidth {
    SmoothedAnimation {
      velocity: animationVelocity
      duration: animationDuration
    }
  }
	Behavior on color { PropertyAnimation { duration: animationDuration } }

  visible: !Config.isSpecialWorkspace(modelData?.name)
  color: modelData?.focused ? focusedColor : modelData?.active ? activeColor : emptyColor
}
