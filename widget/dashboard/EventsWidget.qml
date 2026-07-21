import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.io
import qs.component
import qs

// Events/reminders list, persisted to events.json. Add a title + datetime, sorted
// soonest-first; past events are visually dimmed with a one-click "done" to clear them.
DashboardWidget {
	id: root
	title: "Events"
	resizable: true
	implicitWidth: 280
	implicitHeight: 280

	property string newTitle: ""
	property string newWhenText: ""

	readonly property list<var> sortedEvents: adapter.events.slice().sort((a, b) => a.when - b.when)

	function parsedWhen(): date {
		if (newWhenText.trim().length === 0) return Time.time
		const parsed = new Date(newWhenText)
		return isNaN(parsed.getTime()) ? Time.time : parsed
	}

	function addEvent() {
		if (newTitle.trim().length === 0) return
		adapter.events = adapter.events.concat([{
			id: Date.now(),
			title: newTitle.trim(),
			when: Number(root.parsedWhen()),
		}])
		file.writeAdapter()
		newTitle = ""
		titleInput.text = ""
		newWhenText = ""
		whenInput.text = ""
	}

	function deleteEvent(id: var) {
		adapter.events = adapter.events.filter(event => event.id !== id)
		file.writeAdapter()
	}

	FileView {
		id: file
		path: Quickshell.env("HOME") + "/.config/quickshell/data/events.json"
		watchChanges: true
		onFileChanged: reload()

		JsonAdapter {
			id: adapter
			property list<var> events: []
		}
	}

	ColumnLayout {
		anchors.fill: parent
		spacing: Config._.style.widget.margins

		RowLayout {
			Layout.fillWidth: true
			spacing: 4

			Rectangle {
				Layout.fillWidth: true
				implicitHeight: titleInput.implicitHeight + Config._.style.widget.margins * 2
				radius: Config._.style.widget.radius
				color: Config._.style.widget.bg
				border.color: Config._.style.widget.outline
				border.width: Config._.style.widget.border

				TextInput {
					id: titleInput
					anchors.fill: parent
					anchors.margins: Config._.style.widget.margins
					color: Config._.style.widget.fg
					font.family: Config._.font.family
					font.pointSize: Config._.style.widget.fontSize
					selectByMouse: true
					onTextChanged: root.newTitle = text
					onAccepted: root.addEvent()

					Text {
						visible: titleInput.text.length === 0
						text: "Event title…"
						color: Config._.style.widget.outline
						font.family: Config._.font.family
						font.pointSize: Config._.style.widget.fontSize
					}
				}
			}

			Rectangle {
				Layout.preferredWidth: 130
				implicitHeight: whenInput.implicitHeight + Config._.style.widget.margins * 2
				radius: Config._.style.widget.radius
				color: Config._.style.widget.bg
				border.color: Config._.style.widget.outline
				border.width: Config._.style.widget.border

				TextInput {
					id: whenInput
					anchors.fill: parent
					anchors.margins: Config._.style.widget.margins
					color: Config._.style.widget.fg
					font.family: Config._.font.family
					font.pointSize: Config._.style.widget.fontSize
					selectByMouse: true
					onTextChanged: root.newWhenText = text
					onAccepted: root.addEvent()

					Text {
						visible: whenInput.text.length === 0
						text: "YYYY-MM-DD HH:MM"
						color: Config._.style.widget.outline
						font.family: Config._.font.family
						font.pointSize: Config._.style.widget.fontSize - 2
					}
				}
			}

			Text {
				text: "+"
				color: addArea.containsMouse ? Config._.style.panel.accent : Config._.style.panel.fg
				font.family: Config._.font.family
				font.pointSize: Config._.style.widget.fontSize + 6
				MouseArea {
					id: addArea
					anchors.fill: parent
					anchors.margins: -4
					hoverEnabled: true
					cursorShape: Qt.PointingHandCursor
					onClicked: root.addEvent()
				}
			}
		}

		ListView {
			Layout.fillWidth: true
			Layout.fillHeight: true
			clip: true
			spacing: 2
			model: root.sortedEvents

			delegate: Rectangle {
				id: eventRow
				required property var modelData
				property bool isPast: modelData.when < Number(Time.time)

				width: ListView.view.width
				height: 36
				radius: Config._.style.widget.radius
				color: Config._.style.widget.bg
				opacity: isPast ? 0.5 : 1

				RowLayout {
					anchors.fill: parent
					anchors.margins: 6
					spacing: 6

					ColumnLayout {
						Layout.fillWidth: true
						spacing: 0

						Text {
							Layout.fillWidth: true
							text: eventRow.modelData.title
							color: Config._.style.widget.fg
							font.family: Config._.font.family
							font.pointSize: Config._.style.widget.fontSize
							elide: Text.ElideRight
						}
						Text {
							Layout.fillWidth: true
							text: Config.formatDateTime(new Date(eventRow.modelData.when), Locale.ShortFormat)
							color: Config._.style.widget.outline
							font.family: Config._.font.family
							font.pointSize: Config._.style.widget.fontSize - 2
						}
					}

					Text {
						text: "×"
						color: deleteArea.containsMouse ? Config._.style.panel.accent : Config._.style.widget.fg
						font.pointSize: Config._.style.widget.fontSize + 1
						MouseArea {
							id: deleteArea
							anchors.fill: parent
							anchors.margins: -4
							hoverEnabled: true
							cursorShape: Qt.PointingHandCursor
							onClicked: root.deleteEvent(eventRow.modelData.id)
						}
					}
				}
			}
		}
	}
}
