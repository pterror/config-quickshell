import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import qs

// Base card for a widget hosted in `window/WidgetOverlay.qml`; `widget/dashboard/*.qml`
// widgets extend this and fill the default slot.
//
// `instanceId`/`widgetType` and `index` default to placeholders and are assigned by the overlay's
// Loader after instantiation — dynamically-discovered `.qml` files can't receive
// required properties through `Loader.source`.
Rectangle {
	id: root

	property string instanceId: ""
	property string widgetType: ""
	property bool resizable: false
	property bool draggable: false
	property bool closable: false
	property int contentMargins: Config._.style.panel.margins
	// fallback grid slot used only until the widget has a persisted/dragged position
	property int index: 0

	default property alias content: contentArea.data

	readonly property var _instance: Config.widgetInstance(instanceId) ?? ({})
	readonly property var _savedGeometry: _instance
	readonly property int _gridColumns: 4
	readonly property int _gridSpacing: 16
	readonly property bool editing: Config._.widgets.editMode
	readonly property bool canDrag: root.editing || root.draggable
	readonly property bool canClose: root.editing || root.closable

	// Frosted-glass widget card: translucent tint + hairline border + soft drop
	// shadow (the desktop canvas behind it gives plenty of headroom).
	radius: Config._.style.panel.radius
	color: Config._.style.panel.bg
	border.color: Config._.style.panel.outline
	border.width: Config._.style.widget.border

	layer.enabled: true
	layer.effect: MultiEffect {
		shadowEnabled: true
		shadowColor: Config._.style.glass.shadowColor
		shadowBlur: Config._.style.glass.shadowBlur
		shadowVerticalOffset: Config._.style.glass.shadowVerticalOffset
		shadowHorizontalOffset: Config._.style.glass.shadowHorizontalOffset
		blurEnabled: false
	}

	implicitWidth: 240
	implicitHeight: 180
	width: _savedGeometry?.width ?? implicitWidth
	height: _savedGeometry?.height ?? implicitHeight

	x: _savedGeometry?.x ?? _gridSpacing + (index % _gridColumns) * (implicitWidth + _gridSpacing)
	y: _savedGeometry?.y ?? _gridSpacing + Math.floor(index / _gridColumns) * (implicitHeight + _gridSpacing)

	function savePosition() {
		Config.updateWidgetInstance(instanceId, { x: root.x, y: root.y, width: root.width, height: root.height })
	}

	function hide() {
		Config.removeWidgetInstance(instanceId)
	}

	Item {
		id: contentArea
		anchors.fill: parent
		anchors.margins: root.contentMargins
		clip: true
	}

	Timer {
		id: geometrySaveDebounce
		interval: 120
		repeat: false
		onTriggered: root.savePosition()
	}

	MouseArea {
		id: dragMouseArea
		enabled: root.canDrag
		anchors.fill: parent
		z: -1
		hoverEnabled: true
		property real startX: 0
		property real startY: 0
		cursorShape: pressed ? Qt.ClosedHandCursor : (containsMouse ? Qt.OpenHandCursor : Qt.ArrowCursor)
		onPressed: event => {
			startX = event.x
			startY = event.y
		}
		onReleased: root.savePosition()
		onPositionChanged: event => {
			if (!pressed)
				return
			root.x += event.x - startX
			root.y += event.y - startY
			geometrySaveDebounce.restart()
		}
	}

	Rectangle {
		visible: root.canClose
		implicitWidth: closeLabel.implicitWidth + 10
		implicitHeight: closeLabel.implicitHeight + 4
		radius: width / 2
		anchors.right: parent.right
		anchors.top: parent.top
		anchors.margins: 6
		color: closeMouseArea.containsMouse ? Config._.style.barItem.hoverBg : "transparent"

		Text {
			id: closeLabel
			anchors.centerIn: parent
			text: "×"
			color: Config._.style.panel.fg
			font.bold: true
			font.pointSize: Config._.style.widget.fontSize + 1
		}

		MouseArea {
			id: closeMouseArea
			enabled: root.canClose
			anchors.fill: parent
			hoverEnabled: true
			cursorShape: Qt.PointingHandCursor
			onClicked: root.hide()
		}
	}

	Rectangle {
		id: resizeHandle
		visible: root.resizable && root.editing
		width: 12; height: 12
		anchors.right: parent.right
		anchors.bottom: parent.bottom
		anchors.margins: 2
		radius: 2
		color: resizeMouseArea.containsMouse ? Config._.style.panel.accent : Config._.style.panel.outline

		MouseArea {
			id: resizeMouseArea
			enabled: root.editing
			anchors.fill: parent
			anchors.margins: -4
			hoverEnabled: true
			cursorShape: root.editing ? Qt.SizeFDiagCursor : Qt.ArrowCursor
			property real startX: 0
			property real startY: 0
			onPressed: event => { startX = event.x; startY = event.y }
			onPositionChanged: event => {
				root.width = Math.max(120, root.width + (event.x - startX))
				root.height = Math.max(80, root.height + (event.y - startY))
				geometrySaveDebounce.restart()
			}
			onReleased: root.savePosition()
		}
	}
}
