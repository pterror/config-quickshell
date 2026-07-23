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
	property color columnColor: "#ffd166"
	property color sphereColor: "#243142"
	property var heightSource: []
	property bool animateHeights: false
	property real animationPhase: 0

	readonly property var triangles: GeodesicSphere.buildTriangles(radius, frequency)
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
			return Math.max(0, value)
		}
		const phase = animationPhase + index * 0.11
		return 0.5 + 0.5 * Math.sin(phase) * Math.cos(phase * 0.31)
	}

	function rebuildMesh() {
		const positions = []
		const normals = []
		const indexes = []
		let nextIndex = 0

		function pushTriangle(a, b, c, normal) {
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
			indexes.push(nextIndex, nextIndex + 1, nextIndex + 2)
			nextIndex += 3
		}

		for (let i = 0; i < triangles.length; ++i) {
			const tri = triangles[i]
			const height = baseHeight + sampleHeight(i) * heightScale
			const inner = tri
			const outer = tri.map(point => {
				const dir = GeodesicSphere.normalize(point)
				return {
					x: point.x + dir.x * height,
					y: point.y + dir.y * height,
					z: point.z + dir.z * height
				}
			})

			pushTriangle(
				outer[0], outer[2], outer[1],
				GeodesicSphere.triangleNormal(outer[0], outer[2], outer[1])
			)

			for (let edge = 0; edge < 3; ++edge) {
				const next = (edge + 1) % 3
				const a0 = inner[edge]
				const a1 = inner[next]
				const b0 = outer[edge]
				const b1 = outer[next]
				const sideNormal = GeodesicSphere.triangleNormal(a0, b1, a1)
				pushTriangle(a0, b1, a1, sideNormal)
				pushTriangle(a0, b0, b1, sideNormal)
			}
		}

		mesh.positions = positions
		mesh.normals = normals
		mesh.indexes = indexes
	}

	onHeightSourceChanged: {
		_heights = normalizeHeights(heightSource)
		rebuildMesh()
	}
	onTrianglesChanged: rebuildMesh()
	onBaseHeightChanged: rebuildMesh()
	onHeightScaleChanged: rebuildMesh()
	onAnimationPhaseChanged: if (animateHeights || !_heights.length) rebuildMesh()

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
		materials: DefaultMaterial {
			diffuseColor: root.columnColor
			specularRoughness: 0.45
		}
	}

	FrameAnimation {
		running: root.animateHeights && !root._heights.length
		onTriggered: root.animationPhase += frameTime * 0.75
	}
}
