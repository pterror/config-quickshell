import QtQuick

Canvas {
	id: root

	property int sampleCount: 1
	property int textureWidth: Math.max(1, Math.ceil(Math.sqrt(sampleCount)))
	property int textureHeight: Math.max(1, Math.ceil(sampleCount / Math.max(1, textureWidth)))
	property real debugWidth: textureWidth
	property real debugHeight: textureHeight
	property var heightSource: []
	property bool animateHeights: false
	property real animationPhase: 0
	property real animationStep: 0.03
	property int animationInterval: 16

	visible: true
	width: debugWidth
	height: debugHeight
	renderTarget: Canvas.Image
	renderStrategy: Canvas.Immediate

	property var _ctx: null
	property var _heights: []

	function normalizeHeights(source) {
		if (!source)
			return []
		if (source instanceof ArrayBuffer)
			return new Float32Array(source)
		if (ArrayBuffer.isView(source))
			return source
		if (Array.isArray(source))
			return source
		return []
	}

	function sampleHeight(index) {
		if (_heights.length) {
			const value = Number(_heights[index % _heights.length]) || 0
			return Math.max(0, Math.min(1, value))
		}
		const phase = animationPhase + index * 0.15
		return 0.5 + 0.5 * Math.sin(phase) * Math.cos(phase * 0.37)
	}

	function syncBuffer() {
		if (!available)
			return
		_ctx = getContext("2d")
		if (!_ctx)
			return
		requestPaint()
	}

	function faceUv(index) {
		const x = index % root.textureWidth
		const y = Math.floor(index / root.textureWidth)
		return Qt.vector2d(
			(x + 0.5) / Math.max(1, root.textureWidth),
			(y + 0.5) / Math.max(1, root.textureHeight)
		)
	}

	function sampleDebugPixel(index) {
		if (index >= sampleCount)
			return -1
		return Math.round(sampleHeight(index) * 255)
	}

	onPaint: {
		if (!_ctx)
			return
		_ctx.reset()
		_ctx.clearRect(0, 0, width, height)
		const cellWidth = width / Math.max(1, textureWidth)
		const cellHeight = height / Math.max(1, textureHeight)
		for (let i = 0; i < textureWidth * textureHeight; ++i) {
			const inRange = i < sampleCount
			const value = inRange ? Math.round(sampleHeight(i) * 255) : 0
			const x = i % textureWidth
			const y = Math.floor(i / textureWidth)
			_ctx.fillStyle = `rgba(${value}, ${value}, ${value}, ${inRange ? 1 : 0})`
			_ctx.fillRect(x * cellWidth, y * cellHeight, cellWidth, cellHeight)
		}
	}

	onHeightSourceChanged: {
		_heights = normalizeHeights(heightSource)
		syncBuffer()
	}
	onSampleCountChanged: syncBuffer()
	onTextureWidthChanged: syncBuffer()
	onTextureHeightChanged: syncBuffer()
	onAnimationPhaseChanged: if (animateHeights || !_heights.length) syncBuffer()
	onAvailableChanged: if (available) syncBuffer()

	Component.onCompleted: {
		_heights = normalizeHeights(heightSource)
		syncBuffer()
	}

	Timer {
		running: root.animateHeights && !root._heights.length
		repeat: true
		interval: root.animationInterval
		onTriggered: root.animationPhase += root.animationStep
	}
}
