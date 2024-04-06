const MINUTE_MS = 60000;
const HOUR_MS = MINUTE_MS * 60;
const DAY_MS = HOUR_MS * 24;

export function getWallpaperSeed() {
	Math.floor(
		(Number(new Date()) -
			7.5 * HOUR_MS -
			new Date().getTimezoneOffset() * MINUTE_MS) /
			DAY_MS
	);
}
