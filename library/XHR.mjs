/** @param {string} input @param {(xhr: XMLHttpRequest) => void} cb @param {RequestInit} [init] */
export function xhr(input, cb, init = {}) {
	const xhr = new XMLHttpRequest();
	xhr.onreadystatechange = () => {
		if (xhr.readyState === XMLHttpRequest.DONE) {
			cb(xhr);
		}
	};
	xhr.open(init.method ?? "GET", input, true);
	// @ts-expect-error Assume Qt does not have `ReadableStream`.
	xhr.send(init.body ?? "");
}
