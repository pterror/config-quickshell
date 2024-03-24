import QtQuick
import Quickshell

Item {
	required property PopupSurface popupSurface
	required property real expandedWidth
	required property real expandedHeight
	required default property Item widget

	property bool expanded: false

	onExpandedChanged: {
		animateTo(expanded ? 1.0 : 0.0)
		if (expanded) popupSurface.activeOverlay = this
	}

	readonly property bool fullyCollapsed: animationProgress == 0.0

	onFullyCollapsedChanged: {
		if (fullyCollapsed && popupSurface.activeOverlay == this) {
			popupSurface.activeOverlay = null
		}
	}

	readonly property rect collapsedLayerRect: {
		const w = popupSurface.width
		const h = popupSurface.height
		return this.mapToItem(popupSurface.contentItem, 0, 0, width, height)
	}

	readonly property rect expandedLayerRect: popupSurface.expandedPosition(this)

	readonly property rect layerRect: {
		return Qt.rect(
			Config.popoutXCurve.interpolate(animationProgress, collapsedLayerRect.x, expandedLayerRect.x),
			Config.popoutYCurve.interpolate(animationProgress, collapsedLayerRect.y, expandedLayerRect.y),
			Config.popoutXCurve.interpolate(animationProgress, collapsedLayerRect.width, expandedLayerRect.width),
			Config.popoutYCurve.interpolate(animationProgress, collapsedLayerRect.height, expandedLayerRect.height),
		)
	}

	implicitWidth: widget.implicitWidth
	implicitHeight: widget.implicitHeight

	Component.onCompleted: {
		popupSurface.connectOverlay(this)
		widget.x = Qt.binding(() => layerRect.x)
		widget.y = Qt.binding(() => layerRect.y)
		widget.width = Qt.binding(() => layerRect.width)
		widget.height = Qt.binding(() => layerRect.height)
	}
	Component.onDestruction: {
		popupSurface.disconnectOverlay(this)
	}

	function animateTo(target: real) {
		animationProgressInternal = target * 1000
	}

	property real animationProgress: animationProgressInternal * 0.001
	property real animationProgressInternal: 0.0 // animations seem to only have int precision

	Behavior on animationProgressInternal {
		SmoothedAnimation { velocity: 3000 }
	}

	MouseArea {
		id: mouseArea
		anchors.fill: parent
		hoverEnabled: true
		onPressed: expanded = false

		Rectangle {
			anchors.fill: parent
			color: "transparent"
			radius: Config.layout.widget.radius
			border.color: Config.colors.widget.outline
			border.width: Config.layout.widget.border
			opacity: mouseArea.containsMouse ? 1.0 : 0.0

			Behavior on opacity {
				SmoothedAnimation { velocity: 4 }
			}
		}
	}
}
