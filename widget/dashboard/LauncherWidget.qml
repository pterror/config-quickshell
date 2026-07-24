import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.io.search
import qs.component
import qs

// Compact searchable launcher. Text query goes through the shared multi-source
// aggregator (`io/search/Search.qml`) — applications, windows, tray items, and the
// inline calculator provider all show up in one ranked list. Click a result to run it.
DashboardWidget {
	id: root
	resizable: true
	implicitWidth: 280
	implicitHeight: 320

	property string query: ""
	property list<var> results: query.length > 0 ? search.search(query) : []

	Search { id: search }

	function run(item: var) {
		item.execute()
		root.query = ""
		queryInput.text = ""
	}

	ColumnLayout {
		anchors.fill: parent
		spacing: Config._.style.widget.margins

		Rectangle {
			Layout.fillWidth: true
			implicitHeight: queryInput.implicitHeight + Config._.style.widget.margins * 2
			radius: Config._.style.widget.radius
			color: Config._.style.widget.bg
			border.color: Config._.style.widget.outline
			border.width: Config._.style.widget.border

			TextInput {
				id: queryInput
				anchors.fill: parent
				anchors.margins: Config._.style.widget.margins
				color: Config._.style.widget.fg
				font.family: Config._.font.family
				font.pointSize: Config._.style.widget.fontSize
				selectByMouse: true
				focus: true
				onTextChanged: root.query = text

				Text {
					visible: queryInput.text.length === 0
					anchors.verticalCenter: parent.verticalCenter
					text: "Search apps, windows, calc…"
					color: Config._.style.widget.outline
					font.family: Config._.font.family
					font.pointSize: Config._.style.widget.fontSize
				}

				Keys.onEscapePressed: { queryInput.text = ""; root.query = "" }
				Keys.onReturnPressed: if (root.results.length > 0) root.run(root.results[0])
			}
		}

		ListView {
			Layout.fillWidth: true
			Layout.fillHeight: true
			clip: true
			spacing: 2
			model: root.results

			delegate: Rectangle {
				id: resultRow
				required property var modelData
				width: ListView.view.width
				height: 40
				radius: Config._.style.widget.radius
				color: resultArea.containsMouse ? Config._.style.widget.hoverBg : "transparent"

				RowLayout {
					anchors.fill: parent
					anchors.margins: 4
					spacing: Config._.style.widget.margins

					Image {
						Layout.preferredWidth: 24
						Layout.preferredHeight: 24
						fillMode: Image.PreserveAspectFit
						source: resultRow.modelData.icon ? Quickshell.iconPath(resultRow.modelData.icon, true) : ""
					}

					ColumnLayout {
						Layout.fillWidth: true
						spacing: 0

						Text {
							Layout.fillWidth: true
							text: resultRow.modelData.title ?? ""
							color: Config._.style.widget.fg
							font.family: Config._.font.family
							font.pointSize: Config._.style.widget.fontSize
							elide: Text.ElideRight
						}

						Text {
							Layout.fillWidth: true
							visible: !!resultRow.modelData.subtitle
							text: resultRow.modelData.subtitle ?? ""
							color: Config._.style.widget.outline
							font.family: Config._.font.family
							font.pointSize: Config._.style.widget.fontSize - 2
							elide: Text.ElideRight
						}
					}

					Text {
						text: resultRow.modelData.source ?? ""
						color: Config._.style.panel.accent
						font.family: Config._.font.family
						font.pointSize: Config._.style.widget.fontSize - 2
					}
				}

				MouseArea {
					id: resultArea
					anchors.fill: parent
					hoverEnabled: true
					cursorShape: Qt.PointingHandCursor
					onClicked: root.run(resultRow.modelData)
				}
			}
		}
	}
}
