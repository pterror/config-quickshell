/** @typedef {{ [key: string]: Config; } | string | boolean | number} Config */
/** @typedef {{ env: (name: string) => string; config?: Config; }} ConfigContext */
import * as userLib from "../config/userLib.mjs";

/** @type {Record<string, (ctx: ConfigContext, ...args: unknown[]) => unknown>} */
const functions = {
	config: (ctx, ...keys) =>
		// @ts-expect-error
		keys.reduce((obj, key) => obj?.[String(key)], ctx.config),
	// @ts-expect-error
	"user-lib": (ctx, key) => userLib[String(key)],
};

/** @param {ConfigContext} ctx @param {unknown[]} expr @returns {unknown} */
function evaluate(ctx, expr) {
	if (expr[0] === "raw") return expr[1];
	const fn =
		typeof expr[0] === "string"
			? functions[expr[0]]
			: Array.isArray(expr[0])
			? evaluate(ctx, expr[0])
			: undefined;
	return fn
		? // @ts-expect-error
		  fn(
				ctx,
				...expr
					.slice(1)
					.map((val) => (Array.isArray(val) ? evaluate(ctx, val) : val))
		  )
		: expr;
}

/** @param {Record<string, Config>} config @param {{ env: (name: string) => string; config?: Config; }} context */
export function evaluateConfig(config, context) {
	const result = { ...config };
	if (!("config" in context)) context = { ...context, config: result };
	for (const key in result) {
		const value = result[key];
		if (Array.isArray(value) && typeof value[0] === "string") {
			// @ts-expect-error
			result[key] = evaluate(context, value);
		} else if (typeof value === "object" && value !== null) {
			result[key] = evaluateConfig(value, context);
		} else {
			// Do nothing.
		}
	}
	return result;
}
