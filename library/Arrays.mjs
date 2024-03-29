/** @template T @param {T[]} array @param {() => number} random */
export const shuffle = (array, random = Math.random) => {
	const newArray = [...array];
	for (let i = array.length - 1; i > 0; i -= 1) {
		const j = Math.floor(random() * i);
		const tmp = newArray[i];
		// @ts-expect-error
		newArray[i] = newArray[j];
		// @ts-expect-error
		newArray[j] = tmp;
	}
	return newArray;
};
