import QtQuick
import QtQuick.Layouts
import qs

Flickable {
	id: root

	property var visualizerDefs: []
	property string category: ""
	property color glassBg: "transparent"
	property color glassBorder: "transparent"
	property color glassBorderLight: "transparent"
	property color accent: "transparent"
	property int cardRadius: 0

	clip: true
	contentWidth: grid.implicitWidth
	contentHeight: grid.implicitHeight
	boundsBehavior: Flickable.StopAtBounds

	GridLayout {
		id: grid
		columns: 3
		rowSpacing: 56
		columnSpacing: 56

		Repeater {
			model: root.visualizerDefs.filter(d => d.category === root.category)

			Item {
				id: card
				required property var modelData
				required property int index

				implicitWidth: modelData.slotSize
				implicitHeight: modelData.slotSize + 40

				property bool pinned: false
				readonly property real preloadMargin: 300
				readonly property bool inView: (card.y + card.height > root.contentY - card.preloadMargin)
					&& (card.y < root.contentY + root.height + card.preloadMargin)
				readonly property bool shouldLoad: card.inView || card.pinned

				Rectangle {
					anchors.fill: parent
					radius: root.cardRadius
					color: card.pinned ? "#1f3b82f6" : root.glassBg
					border.width: 1
					border.color: card.pinned ? root.accent : root.glassBorder

					Rectangle {
						anchors.top: parent.top
						anchors.left: parent.left
						anchors.right: parent.right
						height: 1
						radius: parent.radius
						color: root.glassBorderLight
					}
				}

				MouseArea {
					anchors.fill: parent
					onClicked: card.pinned = !card.pinned
				}

				ColumnLayout {
					anchors.fill: parent
					anchors.margins: 12
					spacing: 8

					Text {
						text: card.modelData.title
						color: "white"
						font.pointSize: -1
						font.pixelSize: 13
						Layout.alignment: Qt.AlignHCenter
						horizontalAlignment: Text.AlignHCenter
						Layout.fillWidth: true
						wrapMode: Text.WordWrap
					}

					Item {
						Layout.fillWidth: true
						Layout.fillHeight: true
						clip: true

						Loader {
							anchors.centerIn: parent
							active: card.shouldLoad
							sourceComponent: card.modelData.component
						}

						Rectangle {
							anchors.centerIn: parent
							visible: !card.shouldLoad
							width: 64
							height: 64
							radius: 32
							color: "transparent"
							border.width: 1
							border.color: root.glassBorderLight

							Text {
								anchors.centerIn: parent
								text: "…"
								color: "#666666"
								font.pointSize: -1
								font.pixelSize: 20
							}
						}
					}
				}

				Rectangle {
					anchors.fill: parent
					radius: root.cardRadius
					color: "transparent"
					border.width: 1
					border.color: card.pinned ? root.accent : root.glassBorder
				}
			}
		}
	}
}
