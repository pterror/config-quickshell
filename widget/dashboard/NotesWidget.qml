import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.component
import qs

// Sticky notes. Each note is free-form text, persisted as a list to notes.json.
DashboardWidget {
	id: root
	title: "Notes"
	resizable: true
	implicitWidth: 260
	implicitHeight: 260

	function addNote() {
		adapter.notes = adapter.notes.concat([{ id: Date.now(), text: "" }])
		file.writeAdapter()
	}

	function deleteNote(id: var) {
		adapter.notes = adapter.notes.filter(note => note.id !== id)
		file.writeAdapter()
	}

	function setNoteText(id: var, text: string) {
		adapter.notes = adapter.notes.map(note => note.id === id ? Object.assign({}, note, { text }) : note)
		saveTimer.restart()
	}

	Timer {
		id: saveTimer
		interval: 600
		onTriggered: file.writeAdapter()
	}

	FileView {
		id: file
		path: Quickshell.env("HOME") + "/.config/quickshell/data/notes.json"
		watchChanges: true
		onFileChanged: reload()

		JsonAdapter {
			id: adapter
			property list<var> notes: []
		}
	}

	ColumnLayout {
		anchors.fill: parent
		spacing: Config._.style.widget.margins

		RowLayout {
			Layout.fillWidth: true

			Item { Layout.fillWidth: true }

			Text {
				text: "+ note"
				color: addArea.containsMouse ? Config._.style.panel.accent : Config._.style.panel.fg
				font.family: Config._.font.family
				font.pointSize: Config._.style.widget.fontSize
				MouseArea {
					id: addArea
					anchors.fill: parent
					anchors.margins: -4
					hoverEnabled: true
					cursorShape: Qt.PointingHandCursor
					onClicked: root.addNote()
				}
			}
		}

		ListView {
			Layout.fillWidth: true
			Layout.fillHeight: true
			clip: true
			spacing: Config._.style.widget.margins
			model: adapter.notes
			delegate: Rectangle {
				id: card
				required property var modelData
				width: ListView.view.width
				height: Math.max(64, noteText.contentHeight + 28)
				radius: Config._.style.widget.radius
				color: Config._.style.widget.bg
				border.color: Config._.style.widget.outline
				border.width: Config._.style.widget.border

				Text {
					id: deleteButton
					anchors.top: parent.top
					anchors.right: parent.right
					anchors.margins: 4
					text: "×"
					color: deleteArea.containsMouse ? Config._.style.panel.accent : Config._.style.panel.fg
					font.pointSize: Config._.style.widget.fontSize + 1
					z: 1

					MouseArea {
						id: deleteArea
						anchors.fill: parent
						anchors.margins: -4
						hoverEnabled: true
						cursorShape: Qt.PointingHandCursor
						onClicked: root.deleteNote(card.modelData.id)
					}
				}

				Flickable {
					anchors.fill: parent
					anchors.margins: 6
					anchors.rightMargin: 20
					contentWidth: width
					contentHeight: noteText.contentHeight
					clip: true

					TextEdit {
						id: noteText
						width: parent.width
						text: card.modelData.text
						color: Config._.style.widget.fg
						font.family: Config._.font.family
						font.pointSize: Config._.style.widget.fontSize
						wrapMode: TextEdit.Wrap
						selectionColor: Config._.style.textSelection.bg
						onTextChanged: {
							if (text !== card.modelData.text) root.setNoteText(card.modelData.id, text)
						}
					}
				}
			}
		}
	}
}
