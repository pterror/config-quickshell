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
	property int allocatedVertexCount: 0
	property int allocatedFaceCount: 0

	readonly property int faceCount: GeodesicSphere.faceTriangleCount(frequency)

	function scheduleRebuild() {
		if (!rebuildTimer.running)
			rebuildTimer.start()
	}

	function allocateMeshStorage(vertexCount, sampleCount) {
		const positions = new Array(vertexCount)
		const normals = new Array(vertexCount)
		const colors = new Array(vertexCount)
		const uv0s = new Array(vertexCount)
		const indexes = new Array(vertexCount)
		for (let i = 0; i < vertexCount; ++i) {
			positions[i] = Qt.vector3d(0, 0, 0)
			normals[i] = Qt.vector3d(0, 1, 0)
			colors[i] = Qt.vector4d(0, 0, 0, 1)
			uv0s[i] = Qt.vector2d(0.5, 0.5)
			indexes[i] = i
		}
		mesh.positions = positions
		mesh.normals = normals
		mesh.colors = colors
		mesh.uv0s = uv0s
		mesh.indexes = indexes
		if (root.heightTextureData) {
			const samplePositions = new Array(sampleCount)
			for (let i = 0; i < sampleCount; ++i)
				samplePositions[i] = Qt.vector3d(0, 1, 0)
			root.heightTextureData.sampleCount = sampleCount
			root.heightTextureData.samplePositions = samplePositions
		}
		root.allocatedVertexCount = vertexCount
		root.allocatedFaceCount = sampleCount
	}

	function rebuildMesh() {
		const startedAt = Date.now()
		const renderedTriangleCount = faceCount * 7
		const vertexCount = renderedTriangleCount * 3
		if (allocatedVertexCount !== vertexCount || allocatedFaceCount !== faceCount)
			allocateMeshStorage(vertexCount, faceCount)

		const positions = mesh.positions
		const normals = mesh.normals
		const colors = mesh.colors
		const uv0s = mesh.uv0s
		const indexes = mesh.indexes
		const samplePositions = root.heightTextureData ? root.heightTextureData.samplePositions : new Array(faceCount)
		let nextVertex = 0

		function pushTriangle(a, b, c, normal, faceIndex, outerA, outerB, outerC) {
			const lookupUv = root.heightTextureData && root.heightTextureData.faceUv
				? (root.heightTextureData.faceUv(faceIndex) || Qt.vector2d(0.5, 0.5))
				: Qt.vector2d(0.5, 0.5)
			const dir = samplePositions[faceIndex]
			const azimuth = (Math.atan2(dir.z, dir.x) + Math.PI) / (Math.PI * 2)
			const elevation = dir.y * 0.5 + 0.5
			const normal3d = GeodesicSphere.toVector3d(normal)
			positions[nextVertex] = GeodesicSphere.toVector3d(a)
			normals[nextVertex] = normal3d
			uv0s[nextVertex] = lookupUv
			colors[nextVertex] = Qt.vector4d(outerA ? 1 : 0, azimuth, elevation, 1)
			indexes[nextVertex] = nextVertex
			++nextVertex

			positions[nextVertex] = GeodesicSphere.toVector3d(b)
			normals[nextVertex] = normal3d
			uv0s[nextVertex] = lookupUv
			colors[nextVertex] = Qt.vector4d(outerB ? 1 : 0, azimuth, elevation, 1)
			indexes[nextVertex] = nextVertex
			++nextVertex

			positions[nextVertex] = GeodesicSphere.toVector3d(c)
			normals[nextVertex] = normal3d
			uv0s[nextVertex] = lookupUv
			colors[nextVertex] = Qt.vector4d(outerC ? 1 : 0, azimuth, elevation, 1)
			indexes[nextVertex] = nextVertex
			++nextVertex
		}

		GeodesicSphere.forEachFaceTriangle(radius, frequency, (triangleIndex, _faceIndex, _row, _column, p0, p1, p2) => {
			const center = GeodesicSphere.normalize(GeodesicSphere.average([p0, p1, p2]))
			samplePositions[triangleIndex] = center

			const d0 = GeodesicSphere.normalize(p0)
			const d1 = GeodesicSphere.normalize(p1)
			const d2 = GeodesicSphere.normalize(p2)
			const e0 = { x: p0.x + d0.x, y: p0.y + d0.y, z: p0.z + d0.z }
			const e1 = { x: p1.x + d1.x, y: p1.y + d1.y, z: p1.z + d1.z }
			const e2 = { x: p2.x + d2.x, y: p2.y + d2.y, z: p2.z + d2.z }

			pushTriangle(
				p0, p1, p2,
				GeodesicSphere.triangleNormal(e0, e1, e2),
				triangleIndex, true, true, true
			)

			const sideNormal0 = GeodesicSphere.triangleNormal(p0, e1, p1)
			pushTriangle(p0, p1, p1, sideNormal0, triangleIndex, false, false, true)
			pushTriangle(p0, p1, p0, sideNormal0, triangleIndex, false, true, true)

			const sideNormal1 = GeodesicSphere.triangleNormal(p1, e2, p2)
			pushTriangle(p1, p2, p2, sideNormal1, triangleIndex, false, false, true)
			pushTriangle(p1, p2, p1, sideNormal1, triangleIndex, false, true, true)

			const sideNormal2 = GeodesicSphere.triangleNormal(p2, e0, p0)
			pushTriangle(p2, p0, p0, sideNormal2, triangleIndex, false, false, true)
			pushTriangle(p2, p0, p2, sideNormal2, triangleIndex, false, true, true)
		})

		console.log(
			"[GeodesicFaceColumnsGpu] rebuildMesh",
			`f=${frequency}`,
			`faces=${faceCount}`,
			`expectedVerts=${vertexCount}`,
			`writtenVerts=${nextVertex}`,
			`ms=${Date.now() - startedAt}`
		)
		if (root.heightTextureData) {
			root.heightTextureData.sampleCount = faceCount
		}
	}

	onFaceCountChanged: scheduleRebuild()
	onRadiusChanged: scheduleRebuild()
	onFrequencyChanged: scheduleRebuild()
	Component.onCompleted: scheduleRebuild()

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
		id: rebuildTimer
		interval: 0
		repeat: false
		onTriggered: root.rebuildMesh()
	}

	Timer {
		running: root.animateHeights
		repeat: true
		interval: 16
		onTriggered: root.animationPhase += 0.016
	}
}
