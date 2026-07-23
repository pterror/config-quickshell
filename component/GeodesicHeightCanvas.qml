import QtQuick

Canvas {
	id: root

	property int sampleCount: 1
	property var heightSource: []
	property bool animateHeights: false
	property real animationPhase: 0
	property real animationStep: 0.03
	property int animationInterval: 16

	visible: true
	opacity: 0
	width: Math.max(1, sampleCount)
	height: 1
	renderTarget: Canvas.Image
	renderStrategy: Canvas.Immediate

	property var _ctx: null
	property var _imageData: null
	property var _pixels: null
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
		if (!_imageData || _imageData.width !== width) {
			_imageData = _ctx.createImageData(width, 1)
			_pixels = _imageData.data
		}
		for (let i = 0; i < sampleCount; ++i) {
			const pixelIndex = i * 4
			const value = Math.round(sampleHeight(i) * 255)
			_pixels[pixelIndex] = value
			_pixels[pixelIndex + 1] = value
			_pixels[pixelIndex + 2] = value
			_pixels[pixelIndex + 3] = 255
		}
		requestPaint()
	}

	onPaint: {
		if (_ctx && _imageData)
			_ctx.putImageData(_imageData, 0, 0)
	}

	onHeightSourceChanged: {
		_heights = normalizeHeights(heightSource)
		syncBuffer()
	}
	onSampleCountChanged: syncBuffer()
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
