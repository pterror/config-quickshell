import QtQuick
import QtQuick3D
import QtQuick3D.Helpers
import "../library/GeodesicSphere.mjs" as GeodesicSphere

Node {
	id: root

	required property Item heightCanvas
	property real radius: 24
	property int frequency: 5
	property real baseHeight: 0.35
	property real heightScale: 10
	property bool showCoreSphere: true
	property color columnColor: "#7bdff2"
	property color sphereColor: "#1d3144"
	property var heightSource: []
	property bool animateHeights: false

	readonly property var triangles: GeodesicSphere.buildTriangles(radius, frequency)

	function rebuildMesh() {
		const positions = []
		const normals = []
		const colors = []
		const uv0s = []
		const indexes = []
		let nextIndex = 0

		function pushTriangle(a, b, c, normal, faceIndex, outerA, outerB, outerC) {
			const lookupUv = root.heightCanvas.faceUv(faceIndex)
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
			uv0s.push(
				lookupUv,
				lookupUv,
				lookupUv
			)
			colors.push(
				Qt.vector4d(outerA ? 1 : 0, 0, 0, 1),
				Qt.vector4d(outerB ? 1 : 0, 0, 0, 1),
				Qt.vector4d(outerC ? 1 : 0, 0, 0, 1)
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
				const sideNormal = GeodesicSphere.triangleNormal(a0, b1, a1)
				// Keep all stored positions on the base sphere; only the
				// outer-flagged duplicates are displaced in the vertex shader.
				pushTriangle(a0, a1, a1, sideNormal, i, false, false, true)
				pushTriangle(a0, a1, a0, sideNormal, i, false, true, true)
			}
		}

		mesh.positions = positions
		mesh.normals = normals
		mesh.colors = colors
		mesh.uv0s = uv0s
		mesh.indexes = indexes
		root.heightCanvas.sampleCount = triangles.length
	}

	onTrianglesChanged: rebuildMesh()
	Component.onCompleted: rebuildMesh()

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
			alwaysDirty: true
			property real uBaseHeight: root.baseHeight
			property real uHeightScale: root.heightScale
			property color uColor: root.columnColor
				property TextureInput uHeightMap: TextureInput {
					enabled: true
					texture: Texture {
						sourceItem: root.heightCanvas
						minFilter: Texture.Nearest
					magFilter: Texture.Nearest
					mipFilter: Texture.None
					generateMipmaps: false
					tilingModeHorizontal: Texture.ClampToEdge
					tilingModeVertical: Texture.ClampToEdge
				}
			}

			shadingMode: CustomMaterial.Shaded
			cullMode: Material.BackFaceCulling
			vertexShader: "../shader/geodesic_face_gpu.vert"
			fragmentShader: "../shader/geodesic_face_gpu.frag"
		}
	}
}
