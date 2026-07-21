import QtQuick
import QtQuick.Layouts
import qs.component
import qs

// Countdown timer. Set H:M:S while stopped, then start/pause/reset. Flashes when it
// reaches zero.
DashboardWidget {
	id: root
	title: "Timer"
	implicitWidth: 240
	implicitHeight: 180

	property int inputHours: 0
	property int inputMinutes: 5
	property int inputSeconds: 0

	property real totalMs: 0
	property real endTime: 0
	property real remainingMs: 0
	property bool running: false
	property bool finished: false

	function inputMs(): real {
		return (inputHours * 3600 + inputMinutes * 60 + inputSeconds) * 1000
	}

	function start() {
		if (remainingMs <= 0) remainingMs = inputMs()
		if (remainingMs <= 0) return
		endTime = Date.now() + remainingMs
		running = true
		finished = false
	}

	function pause() {
		remainingMs = Math.max(0, endTime - Date.now())
		running = false
	}

	function reset() {
		running = false
		finished = false
		remainingMs = inputMs()
	}

	function formatMs(ms: real): string {
		const total = Math.max(0, Math.ceil(ms / 1000))
		const h = Math.floor(total / 3600)
		const m = Math.floor((total % 3600) / 60)
		const s = total % 60
		const pad = n => String(n).padStart(2, "0")
		return h > 0 ? (pad(h) + ":" + pad(m) + ":" + pad(s)) : (pad(m) + ":" + pad(s))
	}

	Component.onCompleted: remainingMs = inputMs()

	Timer {
		interval: 100
		running: root.running
		repeat: true
		onTriggered: {
			root.remainingMs = root.endTime - Date.now()
			if (root.remainingMs <= 0) {
				root.remainingMs = 0
				root.running = false
				root.finished = true
			}
		}
	}

	SequentialAnimation {
		id: flashAnimation
		running: root.finished
		loops: Animation.Infinite
		ColorAnimation { target: display; property: "color"; to: Config._.style.panel.accent; duration: 400 }
		ColorAnimation { target: display; property: "color"; to: Config._.style.panel.fg; duration: 400 }
	}

	ColumnLayout {
		anchors.fill: parent
		spacing: Config._.style.widget.margins

		Text {
			id: display
			Layout.alignment: Qt.AlignHCenter
			text: root.formatMs(root.remainingMs)
			color: Config._.style.panel.fg
			font.family: Config._.font.family
			font.pointSize: 26
			font.bold: true
		}

		RowLayout {
			Layout.alignment: Qt.AlignHCenter
			visible: !root.running && root.remainingMs <= 0
			spacing: 2

			TimerNumberField {
				value: root.inputHours
				max: 99
				onValueEdited: v => root.inputHours = v
			}
			Text { text: ":"; color: Config._.style.panel.fg; font.pointSize: Config._.style.widget.fontSize + 4 }
			TimerNumberField {
				value: root.inputMinutes
				max: 59
				onValueEdited: v => root.inputMinutes = v
			}
			Text { text: ":"; color: Config._.style.panel.fg; font.pointSize: Config._.style.widget.fontSize + 4 }
			TimerNumberField {
				value: root.inputSeconds
				max: 59
				onValueEdited: v => root.inputSeconds = v
			}
		}

		RowLayout {
			Layout.alignment: Qt.AlignHCenter
			spacing: Config._.style.widget.margins

			TimerButton {
				text: root.running ? "Pause" : "Start"
				onClicked: root.running ? root.pause() : root.start()
			}
			TimerButton {
				text: "Reset"
				onClicked: root.reset()
			}
		}
	}
}

component TimerNumberField: Rectangle {
	id: field
	property int value: 0
	property int max: 99
	signal valueEdited(int v)

	implicitWidth: 32
	implicitHeight: 24
	radius: Config._.style.widget.radius
	color: Config._.style.widget.bg
	border.color: Config._.style.widget.outline
	border.width: Config._.style.widget.border

	TextInput {
		anchors.fill: parent
		horizontalAlignment: Text.AlignHCenter
		verticalAlignment: Text.AlignVCenter
		color: Config._.style.widget.fg
		font.family: Config._.font.family
		font.pointSize: Config._.style.widget.fontSize
		text: String(field.value).padStart(2, "0")
		validator: IntValidator { bottom: 0; top: field.max }
		selectByMouse: true
		onEditingFinished: field.valueEdited(Math.min(field.max, Math.max(0, Number(text) || 0)))
	}
}

component TimerButton: Rectangle {
	id: button
	property alias text: label.text
	signal clicked()

	implicitWidth: label.implicitWidth + Config._.style.button.margins * 4
	implicitHeight: label.implicitHeight + Config._.style.button.margins * 2
	radius: Config._.style.button.radius
	color: buttonArea.containsMouse ? Config._.style.button.hoverBg : Config._.style.button.bg
	border.color: Config._.style.button.outline
	border.width: Config._.style.button.border

	Text {
		id: label
		anchors.centerIn: parent
		color: Config._.style.button.fg
		font.family: Config._.font.family
		font.pointSize: Config._.style.widget.fontSize
	}

	MouseArea {
		id: buttonArea
		anchors.fill: parent
		hoverEnabled: true
		cursorShape: Qt.PointingHandCursor
		onClicked: button.clicked()
	}
}
