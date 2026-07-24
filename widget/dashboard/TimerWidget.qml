import QtQuick
import QtQuick.Layouts
import qs.component
import qs

// Countdown timer. Set H:M:S while stopped, then start/pause/reset. Flashes when it
// reaches zero.
DashboardWidget {
	id: root
	contentMargins: 4
	implicitWidth: 192
	implicitHeight: root.running || root.remainingMs > 0 ? 64 : 88

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
		width: parent.width
		anchors.top: parent.top
		anchors.left: parent.left
		anchors.right: parent.right
		spacing: 2

		Text {
			id: display
			Layout.alignment: Qt.AlignHCenter
			text: root.formatMs(root.remainingMs)
			color: Config._.style.panel.fg
			font.family: Config._.font.family
			font.pointSize: 19
			font.bold: true
		}

		RowLayout {
			Layout.alignment: Qt.AlignHCenter
			visible: !root.running && root.remainingMs <= 0
			spacing: 1

			TimerNumberField {
				value: root.inputHours
				max: 99
				implicitWidth: 28
				implicitHeight: 20
				onValueEdited: v => root.inputHours = v
			}
			Text { text: ":"; color: Config._.style.panel.fg; font.pointSize: Config._.style.widget.fontSize + 2 }
			TimerNumberField {
				value: root.inputMinutes
				max: 59
				implicitWidth: 28
				implicitHeight: 20
				onValueEdited: v => root.inputMinutes = v
			}
			Text { text: ":"; color: Config._.style.panel.fg; font.pointSize: Config._.style.widget.fontSize + 2 }
			TimerNumberField {
				value: root.inputSeconds
				max: 59
				implicitWidth: 28
				implicitHeight: 20
				onValueEdited: v => root.inputSeconds = v
			}
		}

		RowLayout {
			Layout.alignment: Qt.AlignHCenter
			spacing: 3

			TimerButton {
				text: root.running ? "Pause" : "Start"
				implicitHeight: 24
				onClicked: root.running ? root.pause() : root.start()
			}
			TimerButton {
				text: "Reset"
				implicitHeight: 24
				onClicked: root.reset()
			}
		}
	}
}
