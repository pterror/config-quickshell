import QtQuick
import Quickshell
import Quickshell.Io
import qs

Scope {
	id: root
	property list<var> list: []
	property list<var> oldList: []
	property int count: list.length
	signal value(int index, int value)

	onValueChanged: {
		if (oldList.length < list.length) {
			oldList = list.map((_, i) => oldList[i])
		} else if (oldList.length > list.length) {
			oldList = oldList.slice(0, list.length)
		}
		for (let i = 0; i < list.length; i += 1) {
			if (list[i] !== oldList[i]) {
				root.value(i, list[i])
				oldList[i] = list[i]
			}
		}
	}
}
