import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import qs.component
import qs

StackView {
	id: root
	required property QsMenuHandle menu
	signal triggered()

	implicitWidth: currentItem?.implicitWidth ?? 0
	implicitHeight: currentItem?.implicitHeight ?? 0

	initialItem: submenuComp.createObject(null, { handle: root.menu })

	pushEnter: Transition { NumberAnimation { duration: 0 } }
	pushExit: Transition { NumberAnimation { duration: 0 } }
	popEnter: Transition { NumberAnimation { duration: 0 } }
	popExit: Transition { NumberAnimation { duration: 0 } }

	Component {
		id: submenuComp

		Column {
			id: submenu
			required property QsMenuHandle handle
			property bool isSubmenu: false
			padding: 4
			spacing: 2

			StackView.onRemoved: destroy()

			QsMenuOpener {
				id: opener
				menu: submenu.handle
			}

			Repeater {
				model: opener.children

				Item {
					id: entry
					required property QsMenuEntry modelData
					implicitWidth: 200
					implicitHeight: modelData.isSeparator ? 9 : 28

					Loader {
						anchors.fill: parent
						active: entry.modelData.isSeparator
						sourceComponent: Item {
							Rectangle {
								anchors.left: parent.left
								anchors.right: parent.right
								anchors.verticalCenter: parent.verticalCenter
								anchors.leftMargin: 8
								anchors.rightMargin: 8
								height: 1
								color: Config._.style.glass.border
							}
						}
					}

					Loader {
						anchors.fill: parent
						active: !entry.modelData.isSeparator
						sourceComponent: Rectangle {
							radius: Config._.style.button.radius
							color: itemMouse.containsMouse ? Config._.style.primaryHoverBg : "transparent"

							Behavior on color { PropertyAnimation { duration: 100 } }

							MouseArea {
								id: itemMouse
								anchors.fill: parent
								hoverEnabled: true
								cursorShape: entry.modelData.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
								onClicked: {
									if (!entry.modelData.enabled) return
									if (entry.modelData.hasChildren) {
										root.push(submenuComp.createObject(null, { handle: entry.modelData, isSubmenu: true }))
									} else {
										entry.modelData.triggered()
										root.triggered()
									}
								}
							}

							RowLayout {
								anchors.fill: parent
								anchors.leftMargin: 8
								anchors.rightMargin: 8
								spacing: 8

								Image {
									visible: entry.modelData.icon !== ""
									source: entry.modelData.icon
									Layout.preferredWidth: 16
									Layout.preferredHeight: 16
									Layout.alignment: Qt.AlignVCenter
								}

								Text {
									Layout.fillWidth: true
									Layout.alignment: Qt.AlignVCenter
									text: entry.modelData.text
									color: entry.modelData.enabled ? Config._.style.primaryFg : Config._.style.secondaryFg
									elide: Text.ElideRight
								}

								Text {
									visible: entry.modelData.hasChildren
									text: "›"
									color: entry.modelData.enabled ? Config._.style.primaryFg : Config._.style.secondaryFg
									font.pixelSize: 16
									Layout.alignment: Qt.AlignVCenter
								}
							}
						}
					}
				}
			}

			Loader {
				active: submenu.isSubmenu
				sourceComponent: Rectangle {
					implicitWidth: backRow.implicitWidth + 16
					implicitHeight: 28
					radius: Config._.style.button.radius
					color: backMouse.containsMouse ? Config._.style.primaryHoverBg : "transparent"

					Behavior on color { PropertyAnimation { duration: 100 } }

					MouseArea {
						id: backMouse
						anchors.fill: parent
						hoverEnabled: true
						cursorShape: Qt.PointingHandCursor
						onClicked: root.pop()
					}

					RowLayout {
						id: backRow
						anchors.fill: parent
						anchors.leftMargin: 8
						anchors.rightMargin: 8
						spacing: 4

						Text {
							text: "‹"
							color: Config._.style.primaryFg
							font.pixelSize: 16
							Layout.alignment: Qt.AlignVCenter
						}
						Text {
							text: "Back"
							color: Config._.style.primaryFg
							Layout.alignment: Qt.AlignVCenter
						}
					}
				}
			}
		}
	}
}
