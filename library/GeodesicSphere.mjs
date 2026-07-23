function v(x, y, z) {
	return { x, y, z }
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

function quantizeKey(p) {
	return [
		Math.round(p.x * 10000),
		Math.round(p.y * 10000),
		Math.round(p.z * 10000)
	].join(":")
}

export function buildPoints(radius, frequency) {
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
	const freq = Math.max(1, Math.floor(frequency))

	for (const face of faces) {
		const a = vertices[face[0]]
		const b = vertices[face[1]]
		const c = vertices[face[2]]
		for (let i = 0; i <= freq; ++i) {
			for (let j = 0; j <= freq - i; ++j) {
				const k = freq - i - j
				const point = normalize(v(
					(a.x * i + b.x * j + c.x * k) / freq,
					(a.y * i + b.y * j + c.y * k) / freq,
					(a.z * i + b.z * j + c.z * k) / freq
				))
				const projected = mul(point, radius)
				const key = quantizeKey(projected)
				if (!unique.has(key)) {
					unique.set(key, true)
					result.push(projected)
				}
			}
		}
	}

	return result
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
