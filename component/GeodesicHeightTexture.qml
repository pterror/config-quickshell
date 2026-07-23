import QtQuick
import QtQuick3D
import QtQuick3D.Helpers

ProceduralTextureData {
	id: root

	property int sampleCount: 1
	property int textureWidth: Math.max(1, Math.ceil(Math.sqrt(sampleCount)))
	property int textureHeight: Math.max(1, Math.ceil(sampleCount / Math.max(1, textureWidth)))
	property var heightSource: []
	property var samplePositions: []
	property bool animateHeights: false
	property int heightMode: 1
	property real constantValue: 0.75
	property real animationPhase: 0
	property real animationStep: 0.03
	property real amplitude: 1
	property real speed: 1
	property real frequencyA: 6.5
	property real frequencyB: 4
	property real twist: 2.3
	property real bias: 0

	width: textureWidth
	height: textureHeight
	hasTransparency: false
	format: TextureData.R8

	property var _heights: []
	property var _buffer: null
	property var _bytes: null

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
		const p = samplePositions[index]
		const x = p?.x ?? Math.sin(index * 1.73)
		const y = p?.y ?? Math.cos(index * 1.19)
		const z = p?.z ?? Math.sin(index * 0.61)
		const phase = animationPhase * speed
		const azimuth = Math.atan2(z, x)
		let value = constantValue

		switch (heightMode) {
		case 0:
			value = constantValue
			break
		case 1:
			value = 0.5 + 0.5 * Math.sin(phase + x * frequencyA + z * frequencyB)
			break
		case 2:
			value = 0.5 + 0.22 * Math.sin(phase * 1.1 + x * frequencyA + z * frequencyB)
				+ 0.18 * Math.cos(phase * 0.8 + y * (frequencyA + 1.5) - x * twist)
				+ 0.10 * Math.sin(phase * 1.7 + (x + y + z) * (frequencyB + 2.0))
			break
		case 3:
			value = 0.5 + 0.5 * Math.sin(phase * 0.7 + y * frequencyA + bias * Math.PI)
			break
		case 4:
			value = 0.5 + 0.5 * Math.sin(phase + azimuth * twist + y * frequencyA)
			break
		case 5:
			value = 1.0 - Math.abs(Math.sin(phase * 1.4 + azimuth * frequencyB + y * frequencyA))
			break
		default:
			value = constantValue
			break
		}

		value = 0.5 + (value - 0.5) * amplitude + bias * 0.5
		return Math.max(0, Math.min(1, value))
	}

	function rebuildTextureData() {
		const byteCount = textureWidth * textureHeight
		if (!_buffer || _buffer.byteLength !== byteCount) {
			_buffer = new ArrayBuffer(byteCount)
			_bytes = new Uint8Array(_buffer)
		}

		for (let i = 0; i < byteCount; ++i)
			_bytes[i] = i < sampleCount ? Math.round(sampleHeight(i) * 255) : 0

		textureData = _buffer
	}

	function faceUv(index) {
		const x = index % textureWidth
		const y = Math.floor(index / textureWidth)
		return Qt.vector2d(
			(x + 0.5) / Math.max(1, textureWidth),
			(y + 0.5) / Math.max(1, textureHeight)
		)
	}

	onHeightSourceChanged: {
		_heights = normalizeHeights(heightSource)
		rebuildTextureData()
	}
	onHeightModeChanged: if (animateHeights || !_heights.length) rebuildTextureData()
	onConstantValueChanged: if (animateHeights || !_heights.length) rebuildTextureData()
	onSamplePositionsChanged: if (animateHeights || !_heights.length) rebuildTextureData()
	onSampleCountChanged: rebuildTextureData()
	onTextureWidthChanged: rebuildTextureData()
	onTextureHeightChanged: rebuildTextureData()
	onAnimationPhaseChanged: if (animateHeights || !_heights.length) rebuildTextureData()
	onAmplitudeChanged: if (animateHeights || !_heights.length) rebuildTextureData()
	onSpeedChanged: if (animateHeights || !_heights.length) rebuildTextureData()
	onFrequencyAChanged: if (animateHeights || !_heights.length) rebuildTextureData()
	onFrequencyBChanged: if (animateHeights || !_heights.length) rebuildTextureData()
	onTwistChanged: if (animateHeights || !_heights.length) rebuildTextureData()
	onBiasChanged: if (animateHeights || !_heights.length) rebuildTextureData()

	Component.onCompleted: {
		_heights = normalizeHeights(heightSource)
		rebuildTextureData()
	}

	Timer {
		running: root.animateHeights && !root._heights.length
		repeat: true
		interval: 16
		onTriggered: root.animationPhase += root.animationStep
	}
}
