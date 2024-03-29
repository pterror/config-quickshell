/** @template T @template [E=void] */
export class Promise {
	/** @param {(resolve: (value: T) => void, reject: (reason: E) => void) => void} fn */
	constructor(fn) {
		/** @type {"pending" | "fulfilled" | "rejected"} */
		this.status = "pending";
		/** @private @type {T} */
		this.value;
		/** @private @type {E} */
		this.reason;
		/** @type {((value: T) => void)[]} */
		this.thens = [];
		/** @type {((reason: E) => void)[]} */
		this.catches = [];
		fn(
			(value) => {
				if (this.status === "pending") {
					this.status = "fulfilled";
					this.value = value;
					if (value instanceof Promise) {
						for (const handler of this.thens) {
							value.then(handler);
						}
					} else {
						for (const handler of this.thens) {
							handler(value);
						}
					}
					this.thens = [];
					this.catches = [];
				}
			},
			(reason) => {
				if (this.status === "pending") {
					this.status = "rejected";
					this.reason = reason;
					for (const handler of this.catches) {
						handler(reason);
					}
					this.thens = [];
					this.catches = [];
				}
			}
		);
	}

	/** @template R
	 * @param {(value: T) => R} onFulfilled
	 * @param {(reason: E) => R} [onRejected]
	 * @return {Promise<R, E>} */
	then(onFulfilled, onRejected) {
		// @ts-expect-error
		if (!onFulfilled && !onRejected) return this;
		if (this.status === "pending") {
			return new Promise((resolve, reject) => {
				if (onFulfilled)
					this.thens.push((value) => resolve(onFulfilled(value)));
				if (onRejected) {
					this.catches.push((reason) => resolve(onRejected(reason)));
				} else {
					this.catches.push((reason) => reject(reason));
				}
			});
		} else if (this.status === "fulfilled") {
			return new Promise((resolve) => resolve(onFulfilled?.(this.value)));
		} else if (this.status === "rejected") {
			// @ts-expect-error
			return new Promise((resolve) => resolve(onRejected?.(this.reason)));
		} else {
			// @ts-expect-error
			return this;
		}
	}

	/** @param {(reason: E) => T} onRejected
	 * @return {Promise<T, E>} */
	catch(onRejected) {
		if (!onRejected) return this;
		if (this.status === "pending") {
			return new Promise((resolve) => {
				this.catches.push((reason) => resolve(onRejected(reason)));
			});
		} else if (this.status === "rejected") {
			return new Promise((resolve) => resolve(onRejected?.(this.reason)));
		} else {
			return this;
		}
	}

	/** @template T @template E @param {T} value @return {Promise<T, E>} */
	static resolve(value) {
		return new Promise((resolve) => resolve(value));
	}

	/** @template E @template T @param {E} reason @return {Promise<T, E>} */
	static reject(reason) {
		return new Promise((_, reject) => reject(reason));
	}
	// TODO: all, allSettled, race
}
