/** @param {string} s */
export function regExpEscape(s) {
	return s.replace(/[\\^$.|?*+()[{]/g, "\\$&");
}
