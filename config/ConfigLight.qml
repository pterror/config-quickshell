import QtQuick
import QtQuick.Effects
import Quickshell
import "root:/io"

ConfigBase {
	id: root
	property Component wallpaperEffect: MultiEffect {}
	Component.onCompleted: {
		wallpapers.folder = Quickshell.env("HOME") + "/.config/wallpapers/light/"
		wallpapers.effect = wallpaperEffect
		colors.primaryFg = "#40080220"
		colors.secondaryFg = "#40080220"
		colors.secondaryBg = "#300f0e0d"
		colors.selectionBg = "#20080f0f"
		colors.accentFg = "#a0cc77aa"
	}
}
