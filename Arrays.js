.pragma library

/** @template {T} @param {T[]} array @param {() => number} random */
const shuffle = (array, random = Math.random) => {
	const newArray = [...array]
	for (let i = array.length - 1; i > 0; i -= 1) {
		const j = Math.floor(random() * i)
		const tmp = newArray[i]
		newArray[i] = newArray[j]
		newArray[j] = tmp
	}
	return newArray
}
