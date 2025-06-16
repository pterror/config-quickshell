import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import Qt.labs.folderlistmodel
import "root:/"
import "root:/library/Arrays.mjs" as Arrays
import "root:/library/Random.mjs" as Random

QtObject {
	property real seed: Config._.wallpapers.seed
	property var wallpapers: getWallpapers()
	readonly property var random: new Random.Random()
	readonly property FolderListModel folder: FolderListModel {
		showDirs: false; showOnlyReadable: true
		folder: "file://" + Config._.wallpapers.folder
		nameFilters: Config._.wallpapers.formats
		onStatusChanged: if (status == FolderListModel.Ready) wallpapers = getWallpapers()
	}

	function getWallpapers() {
		random.seed(seed)
		const unshuffled = []
		for (let i = 0; i < folder.count; i += 1) {
			unshuffled.push(folder.get(i, "filePath"))
		}
		let shuffled = Arrays.shuffle(unshuffled, () => random.random())
		const newWallpapers = {}
		for (const screen of Quickshell.screens) {
			if (shuffled.length === 0) {
				shuffled = Arrays.shuffle(unshuffled, () => random.random());
			}
			newWallpapers[screen.name] = shuffled.pop()
		}
		if (Config._.debug) {
			console.log("New wallpapers:", JSON.stringify(newWallpapers))
		}
		return newWallpapers
	}
	
	onSeedChanged: wallpapers = getWallpapers()
}
