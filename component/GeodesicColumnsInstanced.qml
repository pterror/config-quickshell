import QtQuick
import QtQuick3D
import QtQuick3D.Helpers
import "../library/GeodesicSphere.mjs" as GeodesicSphere

Node {
	id: root

	property real radius: 24
	property int frequency: 5
	property real columnRadius: 0.28
	property real baseHeight: 0.6
	property real heightScale: 11
	property bool showCoreSphere: true
	property color columnColor: "#ffd166"
	property color sphereColor: "#243142"
	property var heightSource: []

	readonly property var points: GeodesicSphere.buildPoints(radius, frequency)
	property var _entries: []
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
		if (!_heights.length) {
			const phase = Date.now() / 900 + index * 0.13
			return 0.5 + 0.5 * Math.sin(phase) * Math.cos(phase * 0.41)
		}
		const value = Number(_heights[index % _heights.length]) || 0
		return Math.max(0, value)
	}

	function clearInstances() {
		for (const entry of _entries)
			entry.destroy()
		_entries = []
	}

	function rebuildInstances() {
		clearInstances()
		for (let i = 0; i < points.length; ++i) {
			const point = points[i]
			_entries.push(instanceEntry.createObject(instancing, {
				position: GeodesicSphere.toVector3d(point),
				rotation: GeodesicSphere.rotationFromUp(GeodesicSphere.normalize(point)),
				scale: Qt.vector3d(columnRadius, 1, columnRadius),
				customData: Qt.vector4d(sampleHeight(i), i, 0, 0),
				color: columnColor
			}))
		}
	}

	function refreshHeights() {
		for (let i = 0; i < _entries.length; ++i) {
			const entry = _entries[i]
			entry.customData = Qt.vector4d(sampleHeight(i), i, 0, 0)
		}
	}

	onHeightSourceChanged: {
		_heights = normalizeHeights(heightSource)
		refreshHeights()
	}
	onPointsChanged: rebuildInstances()
	onColumnRadiusChanged: rebuildInstances()

	Component.onCompleted: {
		_heights = normalizeHeights(heightSource)
		rebuildInstances()
	}

	Component {
		id: instanceEntry

		InstanceListEntry {}
	}

	Model {
		visible: root.showCoreSphere
		geometry: SphereGeometry {
			radius: root.radius
		}
		materials: DefaultMaterial {
			diffuseColor: root.sphereColor
			opacity: 0.14
		}
	}

	InstanceList {
		id: instancing
	}

	Model {
		instancing: instancing
		geometry: CylinderGeometry {
			length: 1
			segments: 10
		}
		materials: CustomMaterial {
			shadingMode: CustomMaterial.Unshaded
			cullMode: Material.BackFaceCulling

			property real uBaseHeight: root.baseHeight
			property real uHeightScale: root.heightScale
			property color uColor: root.columnColor

			vertexShader: "../shader/geodesic_instanced.vert"
			fragmentShader: "../shader/geodesic_instanced.frag"
		}
	}

	FrameAnimation {
		running: !_heights.length
		onTriggered: refreshHeights()
	}
}
