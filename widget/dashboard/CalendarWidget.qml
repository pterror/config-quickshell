import QtQuick
import QtQuick.Layouts
import qs.io
import qs.component
import qs

// Monthly calendar. Navigate months with the arrow buttons; today (real, not the
// viewed month) is highlighted whenever it falls within the visible grid.
DashboardWidget {
	id: root
	title: "Calendar"
	implicitWidth: 260
	implicitHeight: 260

	// first-of-month anchor for the currently viewed month
	property date viewDate: new Date(Time.time.getFullYear(), Time.time.getMonth(), 1)
	readonly property date today: Time.time

	function prevMonth() { viewDate = new Date(viewDate.getFullYear(), viewDate.getMonth() - 1, 1) }
	function nextMonth() { viewDate = new Date(viewDate.getFullYear(), viewDate.getMonth() + 1, 1) }

	function daysInMonth(year: int, month: int): int {
		return new Date(year, month + 1, 0).getDate()
	}

	// Sunday-first weekday index of the 1st of the viewed month
	readonly property int leadingBlanks: viewDate.getDay()
	readonly property int monthLength: daysInMonth(viewDate.getFullYear(), viewDate.getMonth())

	ColumnLayout {
		anchors.fill: parent
		spacing: Config._.style.widget.margins

		RowLayout {
			Layout.fillWidth: true

			Text {
				text: "‹"
				color: prevArea.containsMouse ? Config._.style.panel.accent : Config._.style.panel.fg
				font.family: Config._.font.family
				font.pointSize: Config._.style.widget.fontSize + 4
				MouseArea {
					id: prevArea
					anchors.fill: parent
					anchors.margins: -4
					hoverEnabled: true
					cursorShape: Qt.PointingHandCursor
					onClicked: root.prevMonth()
				}
			}

			Text {
				Layout.fillWidth: true
				horizontalAlignment: Text.AlignHCenter
				text: Time.months[root.viewDate.getMonth()] + " " + root.viewDate.getFullYear()
				color: Config._.style.panel.fg
				font.family: Config._.font.family
				font.pointSize: Config._.style.widget.fontSize
				font.bold: true
			}

			Text {
				text: "›"
				color: nextArea.containsMouse ? Config._.style.panel.accent : Config._.style.panel.fg
				font.family: Config._.font.family
				font.pointSize: Config._.style.widget.fontSize + 4
				MouseArea {
					id: nextArea
					anchors.fill: parent
					anchors.margins: -4
					hoverEnabled: true
					cursorShape: Qt.PointingHandCursor
					onClicked: root.nextMonth()
				}
			}
		}

		GridLayout {
			Layout.fillWidth: true
			columns: 7
			columnSpacing: 2
			rowSpacing: 2

			Repeater {
				model: ["S", "M", "T", "W", "T", "F", "S"]
				Text {
					Layout.fillWidth: true
					horizontalAlignment: Text.AlignHCenter
					text: modelData
					color: Config._.style.panel.accent
					font.family: Config._.font.family
					font.pointSize: Config._.style.widget.fontSize - 1
					font.bold: true
				}
			}
		}

		GridLayout {
			Layout.fillWidth: true
			Layout.fillHeight: true
			columns: 7
			columnSpacing: 2
			rowSpacing: 2

			Repeater {
				model: 42

				Rectangle {
					id: cell
					required property int index
					property int dayNumber: index - root.leadingBlanks + 1
					property bool inMonth: dayNumber >= 1 && dayNumber <= root.monthLength
					property bool isToday: inMonth
						&& root.viewDate.getFullYear() === root.today.getFullYear()
						&& root.viewDate.getMonth() === root.today.getMonth()
						&& dayNumber === root.today.getDate()

					Layout.fillWidth: true
					Layout.fillHeight: true
					radius: Config._.style.widget.radius
					color: isToday ? Config._.style.panel.accent : "transparent"
					visible: inMonth

					Text {
						anchors.centerIn: parent
						text: cell.dayNumber
						color: cell.isToday ? Config._.style.panel.bg : Config._.style.panel.fg
						font.family: Config._.font.family
						font.pointSize: Config._.style.widget.fontSize - 1
					}
				}
			}
		}
	}
}
