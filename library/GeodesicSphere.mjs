function v(x, y, z) {
	return { x, y, z }
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

export function normalize(a) {
	const len = lengthOf(a)
	return len > 0 ? mul(a, 1 / len) : v(0, 1, 0)
}

export function toVector3d(a) {
	return Qt.vector3d(a.x, a.y, a.z)
}

export function toVector4d(a) {
	return Qt.vector4d(a.x, a.y, a.z, a.w)
}

const ICOSA_DATA = (() => {
	const t = (1 + Math.sqrt(5)) / 2
	return {
		vertices: [
			v(-1, t, 0), v(1, t, 0), v(-1, -t, 0), v(1, -t, 0),
			v(0, -1, t), v(0, 1, t), v(0, -1, -t), v(0, 1, -t),
			v(t, 0, -1), v(t, 0, 1), v(-t, 0, -1), v(-t, 0, 1)
		].map(normalize),
		faces: [
			[0, 11, 5], [0, 5, 1], [0, 1, 7], [0, 7, 10], [0, 10, 11],
			[1, 5, 9], [5, 11, 4], [11, 10, 2], [10, 7, 6], [7, 1, 8],
			[3, 9, 4], [3, 4, 2], [3, 2, 6], [3, 6, 8], [3, 8, 9],
			[4, 9, 5], [2, 4, 11], [6, 2, 10], [8, 6, 7], [9, 8, 1]
		]
	}
})()

function facePoint(a, b, c, u, vCoord, radius) {
	const w = 1 - u - vCoord
	return mul(normalize(v(
		a.x * w + b.x * u + c.x * vCoord,
		a.y * w + b.y * u + c.y * vCoord,
		a.z * w + b.z * u + c.z * vCoord
	)), radius)
}

function faceVertices(faceIndex) {
	const face = ICOSA_DATA.faces[faceIndex]
	return [
		ICOSA_DATA.vertices[face[0]],
		ICOSA_DATA.vertices[face[1]],
		ICOSA_DATA.vertices[face[2]]
	]
}

export function faceTriangleCount(frequency) {
	const freq = Math.max(1, Math.floor(frequency))
	return 20 * freq * freq
}

export function pointCount(frequency) {
	return faceTriangleCount(frequency) * 3
}

export function sampleFacePoint(faceIndex, frequency, row, column, radius) {
	const freq = Math.max(1, Math.floor(frequency))
	const [a, b, c] = faceVertices(faceIndex)
	return facePoint(a, b, c, row / freq, column / freq, radius)
}

export function forEachFaceTriangle(radius, frequency, callback) {
	const freq = Math.max(1, Math.floor(frequency))
	let triangleIndex = 0

	for (let faceIndex = 0; faceIndex < ICOSA_DATA.faces.length; ++faceIndex) {
		const [a, b, c] = faceVertices(faceIndex)
		for (let row = 0; row < freq; ++row) {
			for (let column = 0; column < freq - row; ++column) {
				const p0 = facePoint(a, b, c, row / freq, column / freq, radius)
				const p1 = facePoint(a, b, c, (row + 1) / freq, column / freq, radius)
				const p2 = facePoint(a, b, c, row / freq, (column + 1) / freq, radius)
				callback(triangleIndex++, faceIndex, row, column, p0, p1, p2)
				if (column < freq - row - 1) {
					const p3 = facePoint(a, b, c, (row + 1) / freq, (column + 1) / freq, radius)
					callback(triangleIndex++, faceIndex, row, column, p1, p3, p2)
				}
			}
		}
	}
}

export function buildPoints(radius, frequency) {
	const points = new Array(pointCount(frequency))
	let index = 0
	forEachFaceTriangle(radius, frequency, (_triangleIndex, _faceIndex, _row, _column, a, b, c) => {
		points[index++] = a
		points[index++] = b
		points[index++] = c
	})
	return points
}

export function buildTriangles(radius, frequency) {
	const triangles = new Array(faceTriangleCount(frequency))
	forEachFaceTriangle(radius, frequency, (triangleIndex, _faceIndex, _row, _column, a, b, c) => {
		triangles[triangleIndex] = [a, b, c]
	})
	return triangles
}

export function triangleNormal(a, b, c) {
	return normalize(cross(sub(b, a), sub(c, a)))
}

export function average(points) {
	let sum = v(0, 0, 0)
	for (const point of points)
		sum = add(sum, point)
	return mul(sum, 1 / Math.max(1, points.length))
}

export function rotationFromUp(normal) {
	const up = v(0, 1, 0)
	const d = dot(up, normal)
	if (d > 0.999999)
		return Qt.quaternion(1, 0, 0, 0)
	if (d < -0.999999)
		return Qt.quaternion(0, 1, 0, 0)

	const axis = cross(up, normal)
	const q = {
		w: 1 + d,
		x: axis.x,
		y: axis.y,
		z: axis.z
	}
	const qLen = Math.sqrt(q.w * q.w + q.x * q.x + q.y * q.y + q.z * q.z)
	return Qt.quaternion(q.w / qLen, q.x / qLen, q.y / qLen, q.z / qLen)
}
