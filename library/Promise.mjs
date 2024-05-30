/** @template T @template [E=void] */
export class Promise {
	/** @param {(resolve: (value: T) => void, reject: (reason: E) => void) => void} fn */
	constructor(fn) {
		/** @protected @type {"pending" | "fulfilled" | "rejected"} */
		this.status = "pending";
		/** @protected @type {T} */
        this.value = null;
		/** @protected @type {E} */
        this.reason = null;
		/** @protected @type {((value: T) => void)[]} */
		this.thens = [];
		/** @protected @type {((reason: E) => void)[]} */
		this.catches = [];
		/** @param {E} reason */
		const reject = (reason) => {
			if (this.status === "pending") {
				this.status = "rejected";
				this.reason = reason;
				for (const handler of this.catches) {
					handler(reason);
				}
				this.thens = [];
				this.catches = [];
			}
		};
		/** @param {T} value */
		const resolve = (value) => {
			if (this.status === "pending") {
				this.value = value;
				if (value instanceof Promise) {
					value.then(resolve, reject);
					value.thens.push(...this.thens);
					value.catches.push(...this.catches);
				} else {
					this.status = "fulfilled";
					for (const handler of this.thens) {
						handler(value);
					}
				}
				this.thens = [];
				this.catches = [];
			}
		};
		fn(resolve, reject);
	}

	toString() {
		return "<Promise status=" + this.status + ">";
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
				if (onFulfilled) {
					this.thens.push((value) => resolve(onFulfilled(value)));
				}
				if (onRejected) {
					this.catches.push((reason) => resolve(onRejected(reason)));
				} else {
					this.catches.push(reject);
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
		/** @type {Promise<T, E>} */
		const result = new Promise(() => {});
		result.status = "fulfilled";
		result.value = value;
		return result;
	}

	/** @template E @template T @param {E} reason @return {Promise<T, E>} */
	static reject(reason) {
		/** @type {Promise<T, E>} */
		const result = new Promise(() => {});
		result.status = "rejected";
		result.reason = reason;
		return result;
	}
	// TODO: all, allSettled, race
}
