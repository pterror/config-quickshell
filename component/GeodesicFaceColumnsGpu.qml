import QtQuick
import QtQuick3D
import QtQuick3D.Helpers
import "../library/GeodesicSphere.mjs" as GeodesicSphere

Node {
	id: root

	property real radius: 24
	property int frequency: 5
	property real baseHeight: 0.35
	property real heightScale: 10
	property bool showCoreSphere: true
	property color columnColor: "#7bdff2"
	property color sphereColor: "#1d3144"
	property var heightSource: []
	property bool animateHeights: false
	property real animationPhase: 0

	property var _heights: []
	property var _vertexMeta: []

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
			return Math.max(0, value)
		}
		const phase = animationPhase + index * 0.11
		return 0.5 + 0.5 * Math.sin(phase) * Math.cos(phase * 0.31)
	}

	function refreshColors() {
		const colors = []
		for (const meta of _vertexMeta) {
			const h = sampleHeight(meta.faceIndex)
			colors.push(Qt.vector4d(h, meta.outer ? 1 : 0, 0, 1))
		}
		mesh.colors = colors
	}

	readonly property var triangles: GeodesicSphere.buildTriangles(radius, frequency)

	function rebuildMesh() {
		const positions = []
		const normals = []
		const colors = []
		const indexes = []
		let nextIndex = 0
		const vertexMeta = []

		function pushTriangle(a, b, c, normal, faceIndex, outerA, outerB, outerC) {
			positions.push(
				GeodesicSphere.toVector3d(a),
				GeodesicSphere.toVector3d(b),
				GeodesicSphere.toVector3d(c)
			)
			normals.push(
				GeodesicSphere.toVector3d(normal),
				GeodesicSphere.toVector3d(normal),
				GeodesicSphere.toVector3d(normal)
			)
			vertexMeta.push(
				{ faceIndex, outer: outerA },
				{ faceIndex, outer: outerB },
				{ faceIndex, outer: outerC }
			)
			const h = sampleHeight(faceIndex)
			colors.push(
				Qt.vector4d(h, outerA ? 1 : 0, 0, 1),
				Qt.vector4d(h, outerB ? 1 : 0, 0, 1),
				Qt.vector4d(h, outerC ? 1 : 0, 0, 1)
			)
			indexes.push(nextIndex, nextIndex + 1, nextIndex + 2)
			nextIndex += 3
		}

		for (let i = 0; i < triangles.length; ++i) {
			const tri = triangles[i]
			const dirs = tri.map(point => GeodesicSphere.normalize(point))
			const extruded = tri.map((point, idx) => ({
				x: point.x + dirs[idx].x,
				y: point.y + dirs[idx].y,
				z: point.z + dirs[idx].z
			}))

			pushTriangle(
				tri[0], tri[1], tri[2],
				GeodesicSphere.triangleNormal(extruded[0], extruded[1], extruded[2]),
				i, true, true, true
			)

			for (let edge = 0; edge < 3; ++edge) {
				const next = (edge + 1) % 3
				const a0 = tri[edge]
				const a1 = tri[next]
				const b0 = extruded[edge]
				const b1 = extruded[next]
				const sideNormal = GeodesicSphere.triangleNormal(a0, a1, b1)
				pushTriangle(a0, a1, a1, sideNormal, i, false, false, true)
				pushTriangle(a0, a1, a0, sideNormal, i, false, true, true)
			}
		}

		mesh.positions = positions
		mesh.normals = normals
		mesh.colors = colors
		mesh.indexes = indexes
		_vertexMeta = vertexMeta
	}

	onTrianglesChanged: rebuildMesh()
	onHeightSourceChanged: {
		_heights = normalizeHeights(heightSource)
		refreshColors()
	}
	onAnimationPhaseChanged: if (animateHeights || !_heights.length) refreshColors()

	Component.onCompleted: {
		_heights = normalizeHeights(heightSource)
		rebuildMesh()
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

	Model {
		geometry: ProceduralMesh {
			id: mesh
			primitiveMode: ProceduralMesh.Triangles
		}
		materials: CustomMaterial {
			property real uBaseHeight: root.baseHeight
			property real uHeightScale: root.heightScale
			property color uColor: root.columnColor

			shadingMode: CustomMaterial.Shaded
			cullMode: Material.BackFaceCulling
			vertexShader: "../shader/geodesic_face_gpu.vert"
			fragmentShader: "../shader/geodesic_face_gpu.frag"
		}
	}

	FrameAnimation {
		running: root.animateHeights && !root._heights.length
		onTriggered: root.animationPhase += frameTime * 0.75
	}
}
