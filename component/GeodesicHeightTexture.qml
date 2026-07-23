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
	property real animationPhase: 0
	property real animationStep: 0.03
	property int animationInterval: 16

	width: textureWidth
	height: textureHeight
	hasTransparency: false
	format: TextureData.R8

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
		const p = samplePositions[index]
		if (!p) {
			const phase = animationPhase + index * 0.15
			return 0.5 + 0.5 * Math.sin(phase) * Math.cos(phase * 0.37)
		}

		const waveA = Math.sin(animationPhase * 1.25 + p.x * 6.2 + p.z * 4.8)
		const waveB = Math.cos(animationPhase * 0.9 + p.y * 7.4 - p.x * 3.1 + p.z * 2.7)
		const band = Math.sin(animationPhase * 0.6 + Math.atan2(p.z, p.x) * 5.0 + p.y * 3.5)
		const combined = 0.5 + 0.28 * waveA + 0.18 * waveB + 0.12 * band
		return Math.max(0, Math.min(1, combined))
	}

	function rebuildTextureData() {
		const buffer = new ArrayBuffer(textureWidth * textureHeight)
		const bytes = new Uint8Array(buffer)
		for (let i = 0; i < textureWidth * textureHeight; ++i)
			bytes[i] = i < sampleCount ? Math.round(sampleHeight(i) * 255) : 0
		textureData = buffer
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
	onSamplePositionsChanged: if (animateHeights || !_heights.length) rebuildTextureData()
	onSampleCountChanged: rebuildTextureData()
	onTextureWidthChanged: rebuildTextureData()
	onTextureHeightChanged: rebuildTextureData()
	onAnimationPhaseChanged: if (animateHeights || !_heights.length) rebuildTextureData()

	Component.onCompleted: {
		_heights = normalizeHeights(heightSource)
		rebuildTextureData()
	}

	Timer {
		running: root.animateHeights && !root._heights.length
		repeat: true
		interval: root.animationInterval
		onTriggered: root.animationPhase += root.animationStep
	}
}
