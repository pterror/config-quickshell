/** @param {string} name @returns {string} */
export function guessIcon(name) {
	// See https://github.com/end-4/dots-hyprland/blob/9d6452aaaf3723f2fcce38fdd90e62168e41bb3f/.config/quickshell/services/AppSearch.qml#L17-L27
	return (
		{
			"code-url-handler": "visual-studio-code",
			Code: "visual-studio-code",
			"gnome-tweaks": "org.gnome.tweaks",
			"pavucontrol-qt": "pavucontrol",
			wps: "wps-office2019-kprometheus",
			wpsoffice: "wps-office2019-kprometheus",
			footclient: "foot",
			zen: "zen-browser",
			"brave-browser": "brave-desktop",
		}[name] ?? name
	);
}
