const EXPR_REGEX = /^[-+*/%^&|~()\da-febox.\s]+$/;

/** @param {string} s */
const mayBeExpr = (s) => EXPR_REGEX.test(s);

const LEX_REGEX =
	/\s+|[*][*]|[-+%*^/|&~()]|0x[0-9a-f]+|0b[0-1]+|0o[0-7]+|(?:\d+(?:[.]\d*)?|[.](\d+))(?:e[+-]?\d+)?/giy;

/** @param {string} s */
export const calculate = (s) => {
	if (!mayBeExpr(s)) {
		return;
	}
	const tokens = (s.match(LEX_REGEX) ?? []).filter((s) => /\S/.test(s));
	let i = 0;

	const peek = () => tokens[i] ?? "";

	/** @param {string} token */
	const eat = (token) => {
		if (peek() !== token) {
			throw new Error(`Calculate: Expected '${token}', got '${peek()}'`);
		}
		i += 1;
	};

	const parseFactor = () => {
		const token = peek();
		if (/\d|^0[obx]/i.test(token)) {
			eat(token);
			return Number(token);
		}
		eat("(");
		const result = parseExpr();
		eat(")");
		return result;
	};

	const parseUnary = () => {
		switch (peek()) {
			case "-": {
				eat("-");
				return -parseFactor();
			}
			case "~": {
				eat("~");
				return ~parseFactor();
			}
			default: {
				return parseFactor();
			}
		}
	};

	const parsePower = () => {
		let results = [parseUnary()];
		while (true) {
			switch (peek()) {
				case "**": {
					eat("**");
					results.push(parseUnary());
					break;
				}
				default: {
					return results.reduceRight((c, n) => c ** n);
				}
			}
		}
	};

	const parseTerm = () => {
		let result = parsePower();
		while (true) {
			switch (peek()) {
				case "*": {
					eat("*");
					result *= parsePower();
					break;
				}
				case "/": {
					eat("/");
					result /= parsePower();
					break;
				}
				case "%": {
					eat("%");
					result %= parsePower();
					break;
				}
				default: {
					return result;
				}
			}
		}
	};

	const parseAddSub = () => {
		let result = parseTerm();
		while (true) {
			switch (peek()) {
				case "+": {
					eat("+");
					result += parseTerm();
					break;
				}
				case "-": {
					eat("-");
					result -= parseTerm();
					break;
				}
				default: {
					return result;
				}
			}
		}
	};

	/** @returns {number} */
	const parseBitwise = () => {
		let result = parseAddSub();
		while (true) {
			switch (peek()) {
				case "&": {
					eat("&");
					result &= parseAddSub();
					break;
				}
				case "|": {
					eat("|");
					result |= parseAddSub();
					break;
				}
				case "^": {
					eat("^");
					result ^= parseAddSub();
					break;
				}
				default: {
					return result;
				}
			}
		}
	};

	const parseExpr = parseBitwise;

	return parseExpr();
};
