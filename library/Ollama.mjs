// @ts-nocheck
import { Promise } from "./Promise.mjs";

var __awaiter =
	(this && this.__awaiter) ||
	function (thisArg, _arguments, P, generator) {
		function adopt(value) {
			return value instanceof P
				? value
				: new P(function (resolve) {
						resolve(value);
				  });
		}
		return new (P || (P = Promise))(function (resolve, reject) {
			function fulfilled(value) {
				try {
					step(generator.next(value));
				} catch (e) {
					reject(e);
				}
			}
			function rejected(value) {
				try {
					step(generator["throw"](value));
				} catch (e) {
					reject(e);
				}
			}
			function step(result) {
				result.done
					? resolve(result.value)
					: adopt(result.value).then(fulfilled, rejected);
			}
			step((generator = generator.apply(thisArg, _arguments || [])).next());
		});
	};
import * as utils from "./utils.js";
import { AbortableAsyncIterator, parseJSON } from "./utils.js";
import "whatwg-fetch";
import { defaultHost } from "./constant.js";
export class Ollama {
	constructor(config) {
		var _a, _b;
		this.ongoingStreamedRequests = [];
		this.config = {
			host: "",
			headers: config === null || config === void 0 ? void 0 : config.headers,
		};
		if (!(config === null || config === void 0 ? void 0 : config.proxy)) {
			this.config.host = utils.formatHost(
				(_a = config === null || config === void 0 ? void 0 : config.host) !==
					null && _a !== void 0
					? _a
					: defaultHost
			);
		}
		this.fetch =
			(_b = config === null || config === void 0 ? void 0 : config.fetch) !==
				null && _b !== void 0
				? _b
				: fetch;
	}
	// Abort any ongoing streamed requests to Ollama
	abort() {
		for (const request of this.ongoingStreamedRequests) {
			request.abort();
		}
		this.ongoingStreamedRequests.length = 0;
	}
	/**
	 * Processes a request to the Ollama server. If the request is streamable, it will return a
	 * AbortableAsyncIterator that yields the response messages. Otherwise, it will return the response
	 * object.
	 * @param endpoint {string} - The endpoint to send the request to.
	 * @param request {object} - The request object to send to the endpoint.
	 * @protected {T | AbortableAsyncIterator<T>} - The response object or a AbortableAsyncIterator that yields
	 * response messages.
	 * @throws {Error} - If the response body is missing or if the response is an error.
	 * @returns {Promise<T | AbortableAsyncIterator<T>>} - The response object or a AbortableAsyncIterator that yields the streamed response.
	 */
	processStreamableRequest(endpoint, request) {
		return __awaiter(this, void 0, void 0, function* () {
			var _a;
			request.stream =
				(_a = request.stream) !== null && _a !== void 0 ? _a : false;
			const host = `${this.config.host}/api/${endpoint}`;
			if (request.stream) {
				const abortController = new AbortController();
				const response = yield utils.post(this.fetch, host, request, {
					signal: abortController.signal,
					headers: this.config.headers,
				});
				if (!response.body) {
					throw new Error("Missing body");
				}
				const itr = parseJSON(response.body);
				const abortableAsyncIterator = new AbortableAsyncIterator(
					abortController,
					itr,
					() => {
						const i = this.ongoingStreamedRequests.indexOf(
							abortableAsyncIterator
						);
						if (i > -1) {
							this.ongoingStreamedRequests.splice(i, 1);
						}
					}
				);
				this.ongoingStreamedRequests.push(abortableAsyncIterator);
				return abortableAsyncIterator;
			}
			const response = yield utils.post(this.fetch, host, request, {
				headers: this.config.headers,
			});
			return yield response.json();
		});
	}
	/**
	 * Encodes an image to base64 if it is a Uint8Array.
	 * @param image {Uint8Array | string} - The image to encode.
	 * @returns {Promise<string>} - The base64 encoded image.
	 */
	encodeImage(image) {
		return __awaiter(this, void 0, void 0, function* () {
			if (typeof image !== "string") {
				// image is Uint8Array, convert it to base64
				const uint8Array = new Uint8Array(image);
				let byteString = "";
				const len = uint8Array.byteLength;
				for (let i = 0; i < len; i++) {
					byteString += String.fromCharCode(uint8Array[i]);
				}
				return btoa(byteString);
			}
			// the string may be base64 encoded
			return image;
		});
	}
	/**
	 * Generates a response from a text prompt.
	 * @param request {GenerateRequest} - The request object.
	 * @returns {Promise<GenerateResponse | AbortableAsyncIterator<GenerateResponse>>} - The response object or
	 * an AbortableAsyncIterator that yields response messages.
	 */
	generate(request) {
		return __awaiter(this, void 0, void 0, function* () {
			if (request.images) {
				request.images = yield Promise.all(
					request.images.map(this.encodeImage.bind(this))
				);
			}
			return this.processStreamableRequest("generate", request);
		});
	}
	/**
	 * Chats with the model. The request object can contain messages with images that are either
	 * Uint8Arrays or base64 encoded strings. The images will be base64 encoded before sending the
	 * request.
	 * @param request {ChatRequest} - The request object.
	 * @returns {Promise<ChatResponse | AbortableAsyncIterator<ChatResponse>>} - The response object or an
	 * AbortableAsyncIterator that yields response messages.
	 */
	chat(request) {
		return __awaiter(this, void 0, void 0, function* () {
			if (request.messages) {
				for (const message of request.messages) {
					if (message.images) {
						message.images = yield Promise.all(
							message.images.map(this.encodeImage.bind(this))
						);
					}
				}
			}
			return this.processStreamableRequest("chat", request);
		});
	}
	/**
	 * Creates a new model from a stream of data.
	 * @param request {CreateRequest} - The request object.
	 * @returns {Promise<ProgressResponse | AbortableAsyncIterator<ProgressResponse>>} - The response object or a stream of progress responses.
	 */
	create(request) {
		return __awaiter(this, void 0, void 0, function* () {
			return this.processStreamableRequest(
				"create",
				Object.assign({}, request)
			);
		});
	}
	/**
	 * Pulls a model from the Ollama registry. The request object can contain a stream flag to indicate if the
	 * response should be streamed.
	 * @param request {PullRequest} - The request object.
	 * @returns {Promise<ProgressResponse | AbortableAsyncIterator<ProgressResponse>>} - The response object or
	 * an AbortableAsyncIterator that yields response messages.
	 */
	pull(request) {
		return __awaiter(this, void 0, void 0, function* () {
			return this.processStreamableRequest("pull", {
				name: request.model,
				stream: request.stream,
				insecure: request.insecure,
			});
		});
	}
	/**
	 * Pushes a model to the Ollama registry. The request object can contain a stream flag to indicate if the
	 * response should be streamed.
	 * @param request {PushRequest} - The request object.
	 * @returns {Promise<ProgressResponse | AbortableAsyncIterator<ProgressResponse>>} - The response object or
	 * an AbortableAsyncIterator that yields response messages.
	 */
	push(request) {
		return __awaiter(this, void 0, void 0, function* () {
			return this.processStreamableRequest("push", {
				name: request.model,
				stream: request.stream,
				insecure: request.insecure,
			});
		});
	}
	/**
	 * Deletes a model from the server. The request object should contain the name of the model to
	 * delete.
	 * @param request {DeleteRequest} - The request object.
	 * @returns {Promise<StatusResponse>} - The response object.
	 */
	delete(request) {
		return __awaiter(this, void 0, void 0, function* () {
			yield utils.del(
				this.fetch,
				`${this.config.host}/api/delete`,
				{ name: request.model },
				{ headers: this.config.headers }
			);
			return { status: "success" };
		});
	}
	/**
	 * Copies a model from one name to another. The request object should contain the name of the
	 * model to copy and the new name.
	 * @param request {CopyRequest} - The request object.
	 * @returns {Promise<StatusResponse>} - The response object.
	 */
	copy(request) {
		return __awaiter(this, void 0, void 0, function* () {
			yield utils.post(
				this.fetch,
				`${this.config.host}/api/copy`,
				Object.assign({}, request),
				{
					headers: this.config.headers,
				}
			);
			return { status: "success" };
		});
	}
	/**
	 * Lists the models on the server.
	 * @returns {Promise<ListResponse>} - The response object.
	 * @throws {Error} - If the response body is missing.
	 */
	list() {
		return __awaiter(this, void 0, void 0, function* () {
			const response = yield utils.get(
				this.fetch,
				`${this.config.host}/api/tags`,
				{
					headers: this.config.headers,
				}
			);
			return yield response.json();
		});
	}
	/**
	 * Shows the metadata of a model. The request object should contain the name of the model.
	 * @param request {ShowRequest} - The request object.
	 * @returns {Promise<ShowResponse>} - The response object.
	 */
	show(request) {
		return __awaiter(this, void 0, void 0, function* () {
			const response = yield utils.post(
				this.fetch,
				`${this.config.host}/api/show`,
				Object.assign({}, request),
				{
					headers: this.config.headers,
				}
			);
			return yield response.json();
		});
	}
	/**
	 * Embeds text input into vectors.
	 * @param request {EmbedRequest} - The request object.
	 * @returns {Promise<EmbedResponse>} - The response object.
	 */
	embed(request) {
		return __awaiter(this, void 0, void 0, function* () {
			const response = yield utils.post(
				this.fetch,
				`${this.config.host}/api/embed`,
				Object.assign({}, request),
				{
					headers: this.config.headers,
				}
			);
			return yield response.json();
		});
	}
	/**
	 * Embeds a text prompt into a vector.
	 * @param request {EmbeddingsRequest} - The request object.
	 * @returns {Promise<EmbeddingsResponse>} - The response object.
	 */
	embeddings(request) {
		return __awaiter(this, void 0, void 0, function* () {
			const response = yield utils.post(
				this.fetch,
				`${this.config.host}/api/embeddings`,
				Object.assign({}, request),
				{
					headers: this.config.headers,
				}
			);
			return yield response.json();
		});
	}
	/**
	 * Lists the running models on the server
	 * @returns {Promise<ListResponse>} - The response object.
	 * @throws {Error} - If the response body is missing.
	 */
	ps() {
		return __awaiter(this, void 0, void 0, function* () {
			const response = yield utils.get(
				this.fetch,
				`${this.config.host}/api/ps`,
				{
					headers: this.config.headers,
				}
			);
			return yield response.json();
		});
	}
}
export default new Ollama();
// export all types from the main entry point so that packages importing types dont need to specify paths
export * from "./interfaces.js";
