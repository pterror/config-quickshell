import QtQuick
import QtQuick.Layouts
import qs.component
import qs

// Stopwatch with millisecond display and lap times.
DashboardWidget {
	id: root
	resizable: true
	contentMargins: 4
	implicitWidth: 240
	readonly property int visibleLapRows: Math.min(root.laps.length, 4)
	readonly property int preferredHeight: 92 + (visibleLapRows > 0 ? visibleLapRows * 20 + 4 : 0)
	property int _lastPreferredHeight: preferredHeight
	implicitHeight: preferredHeight

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

	onPreferredHeightChanged: {
		if (root.height <= _lastPreferredHeight + 1 || root.height < preferredHeight) {
			root.height = preferredHeight
			root.savePosition()
		}
		_lastPreferredHeight = preferredHeight
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
		id: content
		width: parent.width
		anchors.top: parent.top
		anchors.left: parent.left
		anchors.right: parent.right
		spacing: 4

		Text {
			Layout.alignment: Qt.AlignHCenter
			text: root.formatMs(root.elapsedMs)
			color: Config._.style.panel.fg
			font.family: Config._.font.family
			font.pointSize: 21
			font.bold: true
		}

		RowLayout {
			Layout.alignment: Qt.AlignHCenter
			spacing: 4

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
			Layout.preferredHeight: root.visibleLapRows * 20
			clip: true
			model: root.laps
			visible: root.laps.length > 0

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
