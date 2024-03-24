.pragma library

/* From https://github.com/davidbau/xsrand/blob/master/xorshift7.js */

class Random {
	constructor(seed = Number(new Date())) {
		this.seed(seed)
	}

	clone() {
		return Object.assign(new Random(), { x: this.x, i: this.i })
	}

	seed(seed) {
		let j = 0
		let w = 0
		let X = []

		if (seed === seed | 0) {
			w = X[0] = seed
		} else {
			seed = "" + seed
			for (j = 0; j < seed.length; ++j) {
				X[j & 7] = (X[j & 7] << 15) ^ (seed.charCodeAt(j) + X[(j + 1) & 7] << 13)
			}
		}
		while (X.length < 8) X.push(0)
		for (j = 0; j < 8 && X[j] === 0; ++j) {}
		if (j == 8) w = X[7] = -1; else w = X[j]
		this.x = X
		this.i = 0
		for (j = 256; j > 0; j -= 1) this.int32()
	}

	int32() {
		const X = this.x
		const i = this.i
		let t = X[i]; t ^= (t >>> 7); let v = t ^ (t << 24)
		t = X[(i + 1) & 7]; v ^= t ^ (t >>> 10)
		t = X[(i + 3) & 7]; v ^= t ^ (t >>> 3)
		t = X[(i + 4) & 7]; v ^= t ^ (t << 7)
		t = X[(i + 7) & 7]; t = t ^ (t << 13); v ^= t ^ (t << 9)
		X[i] = v
		this.i = (i + 1) & 7
		return v
	}

	random() {
		return (this.int32() >>> 0) / ((1 << 30) * 4)
	}

	double() {
		let result = 0
		do {
			const top = this.int32() >>> 11
			const bot = (this.int32() >>> 0) / ((1 << 30) * 4)
			result = (top + bot) / (1 << 21)
		} while (result === 0)
		return result
	}
}