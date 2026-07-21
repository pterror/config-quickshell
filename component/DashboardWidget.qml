import QtQuick
import QtQuick.Effects
// aliased: this file lives in `component/`, which also has sibling `ColumnLayout.qml` /
// `RowLayout.qml` wrapper components — the bare names would collide with those instead of
// resolving to the real QtQuick.Layouts types (same collision `SpinBox.qml` sidesteps).
import QtQuick.Layouts as QL
import qs

// Base card for a widget hosted in `window/WidgetOverlay.qml`; `widget/dashboard/*.qml`
// widgets extend this and fill the default slot.
//
// `widgetId` and `index` default to placeholders and are assigned by the overlay's
// Loader after instantiation — dynamically-discovered `.qml` files can't receive
// required properties through `Loader.source`.
Rectangle {
	id: root

	property string widgetId: ""
	property string title: ""
	property bool resizable: false
	// fallback grid slot used only until the widget has a persisted/dragged position
	property int index: 0

	default property alias content: contentArea.children

	readonly property var _savedPosition: Config._.widgets.positions[widgetId]
	readonly property int _gridColumns: 4
	readonly property int _gridSpacing: 16

	visible: Config._.widgets.enabled[widgetId] !== false

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
	width: implicitWidth
	height: implicitHeight

	x: _savedPosition?.x ?? _gridSpacing + (index % _gridColumns) * (implicitWidth + _gridSpacing)
	y: _savedPosition?.y ?? _gridSpacing + Math.floor(index / _gridColumns) * (implicitHeight + _gridSpacing)

	function savePosition() {
		const positions = Object.assign({}, Config._.widgets.positions)
		positions[widgetId] = { x: root.x, y: root.y }
		Config._.widgets.positions = positions
	}

	function hide() {
		const enabled = Object.assign({}, Config._.widgets.enabled)
		enabled[widgetId] = false
		Config._.widgets.enabled = enabled
	}

	function show() {
		const enabled = Object.assign({}, Config._.widgets.enabled)
		enabled[widgetId] = true
		Config._.widgets.enabled = enabled
	}

	ColumnLayout {
		id: layout
		anchors.fill: parent
		anchors.margins: Config._.style.panel.margins
		spacing: Config._.style.widget.margins

		RowLayout {
			id: header
			Layout.fillWidth: true
			visible: root.title !== ""

			Text {
				Layout.fillWidth: true
				text: root.title
				color: Config._.style.panel.fg
				font.family: Config._.font.family
				font.pointSize: Config._.style.widget.fontSize
				font.bold: true
				elide: Text.ElideRight
			}

			Text {
				text: "×"
				color: closeMouseArea.containsMouse ? Config._.style.panel.accent : Config._.style.panel.fg
				font.pointSize: Config._.style.widget.fontSize + 2

				MouseArea {
					id: closeMouseArea
					anchors.fill: parent
					anchors.margins: -4
					hoverEnabled: true
					cursorShape: Qt.PointingHandCursor
					onClicked: root.hide()
				}
			}

			MouseArea {
				id: dragMouseArea
				anchors.fill: parent
				z: -1 // let the close button take priority
				property real startX: 0
				property real startY: 0
				cursorShape: Qt.OpenHandCursor
				onPressed: event => { startX = event.x; startY = event.y; cursorShape = Qt.ClosedHandCursor }
				onReleased: { cursorShape = Qt.OpenHandCursor; root.savePosition() }
				onPositionChanged: event => {
					root.x += event.x - startX
					root.y += event.y - startY
				}
			}
		}

		Item {
			id: contentArea
			Layout.fillWidth: true
			Layout.fillHeight: true
		}
	}

	Rectangle {
		id: resizeHandle
		visible: root.resizable
		width: 12; height: 12
		anchors.right: parent.right
		anchors.bottom: parent.bottom
		anchors.margins: 2
		radius: 2
		color: resizeMouseArea.containsMouse ? Config._.style.panel.accent : Config._.style.panel.outline

		MouseArea {
			id: resizeMouseArea
			anchors.fill: parent
			anchors.margins: -4
			hoverEnabled: true
			cursorShape: Qt.SizeFDiagCursor
			property real startX: 0
			property real startY: 0
			onPressed: event => { startX = event.x; startY = event.y }
			onPositionChanged: event => {
				root.width = Math.max(120, root.width + (event.x - startX))
				root.height = Math.max(80, root.height + (event.y - startY))
			}
		}
	}
}
