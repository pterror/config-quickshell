import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "../library/Widgets.mjs" as Widgets
import qs.component
import qs

Item {
	id: root

	implicitWidth: 420
	implicitHeight: content.implicitHeight
	readonly property real contentHeight: content.implicitHeight
	property string hostInstanceId: ""
	property real hostX: NaN
	property real hostY: NaN
	property real hostWidth: NaN
	property real hostHeight: NaN

	function addWidget(widgetType) {
		const host = hostInstanceId ? Config.widgetInstance(hostInstanceId) : null
		const gap = 16
		const options = {}
		const liveX = Number.isFinite(hostX) ? hostX : undefined
		const liveY = Number.isFinite(hostY) ? hostY : undefined
		const liveWidth = Number.isFinite(hostWidth) ? hostWidth : undefined
		if (host || liveX !== undefined || liveY !== undefined) {
			options.x = (liveX ?? host?.x ?? 16) + (liveWidth ?? host?.width ?? root.implicitWidth) + gap
			options.y = liveY ?? host?.y ?? 16
		}
		options.editMode = false
		Widgets.openWidget(Config, widgetType, options)
	}

	Flickable {
		id: flick
		anchors.fill: parent
		clip: true
		contentWidth: width
		contentHeight: content.implicitHeight
		boundsBehavior: Flickable.StopAtBounds

		ScrollBar.vertical: ScrollBar {
			policy: flick.contentHeight > flick.height ? ScrollBar.AsNeeded : ScrollBar.AlwaysOff
		}

		ColumnLayout {
			id: content
			width: flick.width
			spacing: Config._.style.widget.margins

			GridLayout {
				Layout.fillWidth: true
				columns: 2
				columnSpacing: Config._.style.widget.margins
				rowSpacing: Config._.style.widget.margins

				Repeater {
					model: Object.keys(Config.widgetRegistry).filter(widgetType => !Config.widgetDefinition(widgetType)?.internal)

					Rectangle {
						required property var modelData
						readonly property string widgetType: modelData
						readonly property var definition: Config.widgetDefinition(widgetType)
						Layout.fillWidth: true
						Layout.minimumWidth: 0
						implicitHeight: label.implicitHeight + Config._.style.widget.margins * 2
						radius: Config._.style.widget.radius
						color: rowMouseArea.containsMouse ? Config._.style.widget.hoverBg : Config._.style.widget.bg
						border.color: Config._.style.widget.outline
						border.width: Config._.style.widget.border

						MouseArea {
							id: rowMouseArea
							anchors.fill: parent
							hoverEnabled: true
							cursorShape: Qt.PointingHandCursor
							onClicked: root.addWidget(widgetType)
						}

						Text {
							id: label
							anchors.fill: parent
							anchors.margins: Config._.style.widget.margins
							text: definition?.label ?? widgetType
							horizontalAlignment: Text.AlignHCenter
							verticalAlignment: Text.AlignVCenter
							elide: Text.ElideRight
						}
					}
				}
			}
		}
	}
}
