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
	property color columnColor: "#7bdff2"
	property color sphereColor: "#1d3144"
	property Item heightCanvas: null
	property var heightSource: []
	property bool animateHeights: false

	readonly property var points: GeodesicSphere.buildPoints(radius, frequency)
	property var instancingObject: null

	function rebuildInstancingObject() {
		if (instancingObject) {
			instancingObject.destroy()
			instancingObject = null
		}

		let qml = "import QtQuick3D\nInstanceList {\n"
		for (let i = 0; i < points.length; ++i) {
			const point = points[i]
			const rotation = GeodesicSphere.rotationFromUp(GeodesicSphere.normalize(point))
			qml += `InstanceListEntry {
				position: Qt.vector3d(${point.x}, ${point.y}, ${point.z})
				rotation: Qt.quaternion(${rotation.scalar}, ${rotation.x}, ${rotation.y}, ${rotation.z})
				scale: Qt.vector3d(${columnRadius}, 1, ${columnRadius})
				customData: Qt.vector4d(${i}, 0, 0, 0)
				color: "${columnColor}"
			}\n`
		}
		qml += "}\n"
		instancingObject = Qt.createQmlObject(qml, root, "GeodesicTextureInstancing")
	}

	onPointsChanged: {
		rebuildInstancingObject()
		if (heightCanvas)
			heightCanvas.sampleCount = points.length
	}
	onColumnRadiusChanged: rebuildInstancingObject()
	onHeightSourceChanged: if (heightCanvas) heightCanvas.heightSource = heightSource
	onAnimateHeightsChanged: if (heightCanvas) heightCanvas.animateHeights = animateHeights
	onHeightCanvasChanged: {
		if (!heightCanvas)
			return
		heightCanvas.sampleCount = points.length
		heightCanvas.heightSource = heightSource
		heightCanvas.animateHeights = animateHeights
	}

	Component.onCompleted: {
		rebuildInstancingObject()
		if (heightCanvas) {
			heightCanvas.sampleCount = points.length
			heightCanvas.heightSource = heightSource
			heightCanvas.animateHeights = animateHeights
		}
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
		instancing: root.instancingObject
		geometry: CylinderGeometry {
			length: 1
			segments: 10
		}
		materials: CustomMaterial {
			shadingMode: CustomMaterial.Unshaded
			cullMode: Material.BackFaceCulling

			property real uBaseHeight: root.baseHeight
			property real uHeightScale: root.heightScale
			property real uTextureWidth: Math.max(1, root.points.length)
			property color uColor: root.columnColor
			property TextureInput uHeightMap: TextureInput {
				enabled: root.heightCanvas !== null
				texture: Texture {
					sourceItem: root.heightCanvas
				}
			}

			vertexShader: "../shader/geodesic_texture_instanced.vert"
			fragmentShader: "../shader/geodesic_instanced.frag"
		}
	}
}
