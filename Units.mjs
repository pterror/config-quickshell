const byteSuffixes = ["", ..."KMGTPEZY"];

/** @param {number} bytes */
export const bytesToHumanReadable = (bytes) => {
	let exp = 0;
	while (bytes > 1024 && exp + 1 < byteSuffixes.length) {
		exp = exp + 1;
		bytes = bytes / 1024;
	}
	return bytes.toFixed(1) + byteSuffixes[exp];
};
