import Quickshell
import Quickshell.Wayland

WlrLayershell {
	id: root
	required property var bar

	property var popup: null
	property list<variant> overlays: []
	property variant activeOverlay: null
	property variant lastActiveOverlay: null

	onActiveOverlayChanged: {
		if (lastActiveOverlay !== null && lastActiveOverlay !== activeOverlay) {
			lastActiveOverlay.expanded = false
		}

		lastActiveOverlay = activeOverlay
	}

	readonly property rect barRect: this.contentItem.mapFromItem(bar, 0, 0, bar.width, bar.height)
	readonly property real overlayXOffset: barRect.x + barRect.width + 10

	exclusionMode: ExclusionMode.Ignore
	color: "transparent"
	namespace: "shell:bar"

	Variants {
		id: masks
		model: overlays

		Region {
			required property var modelData
			item: modelData == undefined ? null : modelData.widget
		}
	}

	mask: Region {
		regions: masks.instances
	}

	anchors {
		left: true
		top: true
		bottom: true
	}

	width: {
		const extents = overlays
			.filter(overlay => overlay !== undefined && !overlay.fullyCollapsed)
			.map(overlay => overlayXOffset + overlay.expandedWidth)

		return Math.max(barRect.x + barRect.width, ...extents)
	}

	function connectOverlay(overlay: variant) {
		overlay.widget.parent = this.contentItem
		overlays.push(overlay)
	}

	function disconnectOverlay(overlay: variant) {
		const index = overlays.indexOf(overlay)
		if (index !== -1) overlays.splice(index, 1)
	}

	function expandedPosition(overlay: variant): rect {
		const rect = overlay.collapsedLayerRect

		const idealX = rect.x + (rect.width / 2) - (overlay.expandedWidth / 2)
		const x = Math.max(barRect.x, Math.min((barRect.x + barRect.width) - overlay.expandedWidth, idealX))
		const idealY = rect.y + (rect.height / 2) - (overlay.expandedHeight / 2)
		const y = Math.max(barRect.y, Math.min((barRect.y + barRect.height) - overlay.expandedHeight, idealY))


		return Qt.rect(x, y, overlay.expandedWidth, overlay.expandedHeight)
		// return Qt.rect(overlayXOffset, y, overlay.expandedWidth, overlay.expandedHeight)
	}
}
