import QtQuick
import QtQuick3D
import QtQuick3D.Helpers

Node {
	id: root

	property real radius: 36
	property int frequency: 4
	property real columnRadius: 0.35
	property real baseHeight: 0.25
	property real heightScale: 10
	property bool showCoreSphere: true
	property color columnColor: "#f6d365"
	property color sphereColor: "#2a3140"
	property var heightSource: []

	readonly property var points: buildPoints()
	readonly property var heights: normalizeHeights(heightSource)

	function v(x, y, z) {
		return Qt.vector3d(x, y, z)
	}

	function add(a, b) {
		return v(a.x + b.x, a.y + b.y, a.z + b.z)
	}

	function sub(a, b) {
		return v(a.x - b.x, a.y - b.y, a.z - b.z)
	}

	function mul(a, scalar) {
		return v(a.x * scalar, a.y * scalar, a.z * scalar)
	}

	function dot(a, b) {
		return a.x * b.x + a.y * b.y + a.z * b.z
	}

	function cross(a, b) {
		return v(
			a.y * b.z - a.z * b.y,
			a.z * b.x - a.x * b.z,
			a.x * b.y - a.y * b.x
		)
	}

	function lengthOf(a) {
		return Math.sqrt(dot(a, a))
	}

	function normalize(a) {
		const len = lengthOf(a)
		return len > 0 ? mul(a, 1 / len) : v(0, 1, 0)
	}

	function slerpToSphere(a, b, c) {
		return mul(normalize(v(a, b, c)), root.radius)
	}

	function quantizeKey(p) {
		return [
			Math.round(p.x * 10000),
			Math.round(p.y * 10000),
			Math.round(p.z * 10000)
		].join(":")
	}

	function buildPoints() {
		const t = (1 + Math.sqrt(5)) / 2
		const vertices = [
			v(-1, t, 0), v(1, t, 0), v(-1, -t, 0), v(1, -t, 0),
			v(0, -1, t), v(0, 1, t), v(0, -1, -t), v(0, 1, -t),
			v(t, 0, -1), v(t, 0, 1), v(-t, 0, -1), v(-t, 0, 1)
		].map(normalize)
		const faces = [
			[0, 11, 5], [0, 5, 1], [0, 1, 7], [0, 7, 10], [0, 10, 11],
			[1, 5, 9], [5, 11, 4], [11, 10, 2], [10, 7, 6], [7, 1, 8],
			[3, 9, 4], [3, 4, 2], [3, 2, 6], [3, 6, 8], [3, 8, 9],
			[4, 9, 5], [2, 4, 11], [6, 2, 10], [8, 6, 7], [9, 8, 1]
		]
		const unique = new Map()
		const result = []
		const freq = Math.max(1, Math.floor(root.frequency))

		for (const face of faces) {
			const a = vertices[face[0]]
			const b = vertices[face[1]]
			const c = vertices[face[2]]
			for (let i = 0; i <= freq; ++i) {
				for (let j = 0; j <= freq - i; ++j) {
					const k = freq - i - j
					const p = slerpToSphere(
						(a.x * i + b.x * j + c.x * k) / freq,
						(a.y * i + b.y * j + c.y * k) / freq,
						(a.z * i + b.z * j + c.z * k) / freq
					)
					const key = quantizeKey(p)
					if (!unique.has(key)) {
						unique.set(key, true)
						result.push(p)
					}
				}
			}
		}

		return result
	}

	function normalizeHeights(source) {
		if (!source)
			return []
		if (source instanceof ArrayBuffer)
			return Array.from(new Float32Array(source))
		if (ArrayBuffer.isView(source))
			return Array.from(source)
		if (Array.isArray(source))
			return source
		return []
	}

	function columnHeight(index) {
		if (!root.heights.length)
			return root.baseHeight
		const value = Number(root.heights[index % root.heights.length]) || 0
		return root.baseHeight + Math.max(0, value) * root.heightScale
	}

	function rotationFromUp(normal) {
		const up = v(0, 1, 0)
		const axis = cross(up, normal)
		const axisLength = lengthOf(axis)
		if (axisLength < 0.000001) {
			return normal.y >= 0
				? Quaternion.fromEulerAngles(0, 0, 0)
				: Quaternion.fromAxisAndAngle(v(1, 0, 0), 180)
		}
		const angle = Math.acos(Math.max(-1, Math.min(1, dot(up, normal)))) * 180 / Math.PI
		return Quaternion.fromAxisAndAngle(mul(axis, 1 / axisLength), angle)
	}

	Model {
		visible: root.showCoreSphere
		geometry: SphereGeometry {
			radius: root.radius
		}
		materials: DefaultMaterial {
			diffuseColor: root.sphereColor
			opacity: 0.18
		}
	}

	Repeater3D {
		model: root.points.length

		delegate: Model {
			required property int index

			readonly property vector3d point: root.points[index]
			readonly property vector3d normal: root.normalize(point)
			readonly property real extrudeHeight: root.columnHeight(index)

			position: root.add(point, root.mul(normal, extrudeHeight * 0.5))
			rotation: root.rotationFromUp(normal)
			scale: Qt.vector3d(root.columnRadius, extrudeHeight, root.columnRadius)

			geometry: CylinderGeometry {
				length: 1
				segments: 10
			}

			materials: DefaultMaterial {
				diffuseColor: root.columnColor
				specularRoughness: 0.35
			}
		}
	}
}
