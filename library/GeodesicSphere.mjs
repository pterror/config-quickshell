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

function quantizeKey(p) {
	return [
		Math.round(p.x * 10000),
		Math.round(p.y * 10000),
		Math.round(p.z * 10000)
	].join(":")
}

export function buildPoints(radius, frequency) {
	return buildTriangles(radius, frequency).flat()
}

function icosahedronData() {
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
	return { vertices, faces }
}

function facePoint(a, b, c, u, vCoord) {
	const w = 1 - u - vCoord
	return normalize(v(
		a.x * w + b.x * u + c.x * vCoord,
		a.y * w + b.y * u + c.y * vCoord,
		a.z * w + b.z * u + c.z * vCoord
	))
}

export function buildTriangles(radius, frequency) {
	const { vertices, faces } = icosahedronData()
	const result = []
	const freq = Math.max(1, Math.floor(frequency))

	for (const face of faces) {
		const a = vertices[face[0]]
		const b = vertices[face[1]]
		const c = vertices[face[2]]
		for (let i = 0; i < freq; ++i) {
			for (let j = 0; j < freq - i; ++j) {
				const p0 = mul(facePoint(a, b, c, i / freq, j / freq), radius)
				const p1 = mul(facePoint(a, b, c, (i + 1) / freq, j / freq), radius)
				const p2 = mul(facePoint(a, b, c, i / freq, (j + 1) / freq), radius)
				result.push([p0, p1, p2])
				if (j < freq - i - 1) {
					const p3 = mul(facePoint(a, b, c, (i + 1) / freq, (j + 1) / freq), radius)
					result.push([p1, p3, p2])
				}
			}
		}
	}

	return result
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
