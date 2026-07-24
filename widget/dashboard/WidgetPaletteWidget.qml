import QtQuick
import qs.component
import qs

DashboardWidget {
	id: root
	draggable: true
	closable: true
	implicitWidth: 380
	readonly property real maxHeight: Math.max(220, Math.floor((Screen.height || 900) * 0.6))
	readonly property real idealHeight: palette.contentHeight + Config._.style.panel.margins * 2
	implicitHeight: Math.min(maxHeight, idealHeight)

	WidgetPalette {
		id: palette
		anchors.fill: parent
		hostInstanceId: root.instanceId
		hostX: root.x
		hostY: root.y
		hostWidth: root.width
		hostHeight: root.height
	}
}
