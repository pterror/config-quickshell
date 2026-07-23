import QtQuick
import QtQuick3D
import QtQuick3D.Helpers
import "../library/GeodesicSphere.mjs" as GeodesicSphere

Node {
	id: root

	property QtObject heightTextureData
	property real radius: 24
	property int frequency: 5
	property real baseHeight: 0.35
	property real heightScale: 10
	property bool showCoreSphere: true
	property color columnColor: "#7bdff2"
	property color secondaryColor: "#b2f7ef"
	property color accentColor: "#eff7f6"
	property color sphereColor: "#1d3144"
	property var heightSource: []
	property bool animateHeights: false
	property int renderMode: 0
	property int heightMode: 1
	property int colorMode: 3
	property real amplitude: 1
	property real speed: 1
	property real frequencyA: 6.5
	property real frequencyB: 4
	property real twist: 2.3
	property real bias: 0
	property real banding: 7
	property real colorMix: 0.55
	property real roughnessAmount: 0.82
	property real specularAmount: 0.12
	property real glowAmount: 0.2
	property real animationPhase: 0

	readonly property var triangles: GeodesicSphere.buildTriangles(radius, frequency)
	readonly property var faceCenters: triangles.map(triangle =>
		GeodesicSphere.normalize(GeodesicSphere.average(triangle))
	)

	function rebuildMesh() {
		const positions = []
		const normals = []
		const colors = []
		const uv0s = []
		const indexes = []
		let nextIndex = 0

		function pushTriangle(a, b, c, normal, faceIndex, outerA, outerB, outerC) {
			const lookupUv = root.heightTextureData ? root.heightTextureData.faceUv(faceIndex) : Qt.vector2d(0.5, 0.5)
			const dir = faceCenters[faceIndex]
			const azimuth = (Math.atan2(dir.z, dir.x) + Math.PI) / (Math.PI * 2)
			const elevation = dir.y * 0.5 + 0.5
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
				Qt.vector4d(outerA ? 1 : 0, azimuth, elevation, 1),
				Qt.vector4d(outerB ? 1 : 0, azimuth, elevation, 1),
				Qt.vector4d(outerC ? 1 : 0, azimuth, elevation, 1)
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
		if (root.heightTextureData) {
			root.heightTextureData.sampleCount = triangles.length
			root.heightTextureData.samplePositions = faceCenters
		}
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
			property real uBaseHeight: root.baseHeight
			property real uHeightScale: root.heightScale
			property color uColor: root.columnColor
			property color uSecondaryColor: root.secondaryColor
			property color uAccentColor: root.accentColor
			property real uRenderMode: root.renderMode
			property real uHeightMode: root.heightMode
			property real uColorMode: root.colorMode
			property real uTime: root.animationPhase
			property real uAmplitude: root.amplitude
			property real uSpeed: root.speed
			property real uFrequencyA: root.frequencyA
			property real uFrequencyB: root.frequencyB
			property real uTwist: root.twist
			property real uBias: root.bias
			property real uBanding: root.banding
			property real uColorMix: root.colorMix
			property real uRoughnessAmount: root.roughnessAmount
			property real uSpecularAmount: root.specularAmount
			property real uGlowAmount: root.glowAmount
			property real uHasHeightMap: root.heightTextureData ? 1.0 : 0.0
			property TextureInput uHeightMap: TextureInput {
				enabled: !!root.heightTextureData
				texture: Texture {
					textureData: root.heightTextureData
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

	Timer {
		running: root.animateHeights
		repeat: true
		interval: 16
		onTriggered: root.animationPhase += 0.016
	}
}
