import QtQuick
import QtQuick.Layouts
import qs.component
import qs

// Stopwatch with millisecond display and lap times.
DashboardWidget {
	id: root
	title: "Stopwatch"
	resizable: true
	implicitWidth: 240
	implicitHeight: 220

	property real startTime: 0
	property real accumulatedMs: 0
	property real elapsedMs: 0
	property bool running: false
	property list<var> laps: []

	function start() {
		startTime = Date.now()
		running = true
	}

	function stop() {
		accumulatedMs = elapsedMs
		running = false
	}

	function reset() {
		running = false
		accumulatedMs = 0
		elapsedMs = 0
		laps = []
	}

	function lap() {
		if (!running) return
		laps = [elapsedMs].concat(laps)
	}

	function formatMs(ms: real): string {
		const total = Math.max(0, ms)
		const m = Math.floor(total / 60000)
		const s = Math.floor((total % 60000) / 1000)
		const cs = Math.floor((total % 1000) / 10)
		const pad = (n, len) => String(n).padStart(len ?? 2, "0")
		return pad(m) + ":" + pad(s) + "." + pad(cs)
	}

	Timer {
		interval: 31 // ~30fps is plenty for a centisecond display
		running: root.running
		repeat: true
		onTriggered: root.elapsedMs = root.accumulatedMs + (Date.now() - root.startTime)
	}

	ColumnLayout {
		anchors.fill: parent
		spacing: Config._.style.widget.margins

		Text {
			Layout.alignment: Qt.AlignHCenter
			text: root.formatMs(root.elapsedMs)
			color: Config._.style.panel.fg
			font.family: Config._.font.family
			font.pointSize: 24
			font.bold: true
		}

		RowLayout {
			Layout.alignment: Qt.AlignHCenter
			spacing: Config._.style.widget.margins

			StopwatchButton {
				text: root.running ? "Stop" : "Start"
				onClicked: root.running ? root.stop() : root.start()
			}
			StopwatchButton {
				text: "Lap"
				enabled: root.running
				onClicked: root.lap()
			}
			StopwatchButton {
				text: "Reset"
				enabled: !root.running
				onClicked: root.reset()
			}
		}

		ListView {
			Layout.fillWidth: true
			Layout.fillHeight: true
			clip: true
			model: root.laps

			delegate: RowLayout {
				id: lapRow
				required property var modelData
				required property int index
				width: ListView.view.width

				Text {
					text: "#" + (lapRow.ListView.view.count - lapRow.index)
					color: Config._.style.panel.accent
					font.family: Config._.font.family
					font.pointSize: Config._.style.widget.fontSize - 1
				}
				Item { Layout.fillWidth: true }
				Text {
					text: root.formatMs(lapRow.modelData)
					color: Config._.style.panel.fg
					font.family: Config._.font.family
					font.pointSize: Config._.style.widget.fontSize - 1
				}
			}
		}
	}
}

component StopwatchButton: Rectangle {
	id: button
	property alias text: label.text
	property bool enabled: true
	signal clicked()

	implicitWidth: label.implicitWidth + Config._.style.button.margins * 4
	implicitHeight: label.implicitHeight + Config._.style.button.margins * 2
	opacity: enabled ? 1 : 0.4
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
		enabled: button.enabled
		hoverEnabled: true
		cursorShape: Qt.PointingHandCursor
		onClicked: button.clicked()
	}
}
