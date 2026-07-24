import QtQuick

Item {
	id: root

	property real from: 0
	property real to: 1
	property real stepSize: 0
	property real value: 0
	property bool pressed: mouseArea.pressed

	signal moved(real value)

	implicitWidth: 176
	implicitHeight: 20

	function clampValue(nextValue) {
		const low = Math.min(root.from, root.to)
		const high = Math.max(root.from, root.to)
		return Math.max(low, Math.min(high, nextValue))
	}

	function snapValue(nextValue) {
		const clamped = clampValue(nextValue)
		if (!(root.stepSize > 0))
			return clamped
		const steps = Math.round((clamped - root.from) / root.stepSize)
		return clampValue(root.from + steps * root.stepSize)
	}

	function valueFromPosition(x) {
		const span = root.to - root.from
		if (span === 0)
			return root.from
		const ratio = Math.max(0, Math.min(1, x / Math.max(1, width)))
		return root.from + span * ratio
	}

	function setValueFromPosition(x) {
		const nextValue = snapValue(valueFromPosition(x))
		if (nextValue === root.value)
			return
		root.value = nextValue
		root.moved(root.value)
	}

	readonly property real normalizedValue: {
		const span = root.to - root.from
		if (span === 0)
			return 0
		return (root.value - root.from) / span
	}

	Rectangle {
		id: track
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.verticalCenter: parent.verticalCenter
		height: 6
		radius: 3
		color: "#1cffffff"
		border.width: 1
		border.color: "#26ffffff"

		Rectangle {
			width: Math.max(parent.height, root.normalizedValue * parent.width)
			height: parent.height
			radius: parent.radius
			color: "#70b2f7ef"
		}
	}

	Rectangle {
		width: 16
		height: 16
		radius: 8
		x: Math.max(0, Math.min(parent.width - width, root.normalizedValue * (parent.width - width)))
		y: parent.height / 2 - height / 2
		color: mouseArea.pressed ? "#eff7f6" : "#b2f7ef"
		border.width: 1
		border.color: "#30ffffff"
	}

	MouseArea {
		id: mouseArea
		anchors.fill: parent
		hoverEnabled: true
		preventStealing: true
		cursorShape: Qt.PointingHandCursor
		onPressed: event => root.setValueFromPosition(event.x)
		onPositionChanged: event => {
			if (pressed)
				root.setValueFromPosition(event.x)
		}
	}
}
