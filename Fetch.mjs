import { Promise } from "./Promise.mjs";

export class Headers {
	/** @param {HeadersInit} init */
	constructor(init) {
		/** @private @type {[string, string][]} */
		this._headers = Array.isArray(init) ? init : Object.entries(init);
	}
}

export class Response {
	/** @param {BodyInit} [body] @param {ResponseInit} [options] */
	constructor(body, options) {
		/** @type {string} */
		// @ts-expect-error This is incorrect, but I don't need non-string bodies yet.
		this._body = body ?? null;
		/** @type {number} */
		this.status = options?.status ?? 200;
		/** @type {string} */
		this.statusText = options?.statusText ?? "";
		/** @type {Headers} */
		this.headers = new Headers(options?.headers ?? []);
	}

	/** @return {Promise<string>} */
	text() {
		return Promise.resolve(this._body);
	}

	/** @return {Promise<unknown>} */
	json() {
		return Promise.resolve(JSON.parse(this._body));
	}
}

/** @param {string} input @param {RequestInit} [init] @return {Promise<Response>} */
export function fetch(input, init = {}) {
	return new Promise((resolve) => {
		const xhr = new XMLHttpRequest();
		xhr.onreadystatechange = () => {
			if (xhr.readyState === XMLHttpRequest.DONE) {
				resolve(
					new Response(xhr.responseText, {
						status: xhr.status,
						statusText: xhr.statusText,
						headers: xhr
							.getAllResponseHeaders()
							.split("\r\n")
							.slice(0, -1)
							.map((s) => {
								const [k = "", v = ""] = s.match(/(.+?): (.+)/) ?? [];
								return [k, v];
							}),
					})
				);
			}
		};
		xhr.open(init.method ?? "GET", input, true);
		// @ts-expect-error Assume Qt does not have `ReadableStream`.
		xhr.send(init.body ?? "");
	});
}
