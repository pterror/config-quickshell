import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import "../component"
import "../widget"
import "../io"
import ".."

Variants {
	id: root
	property color backgroundColor: "#e60c0c0c"
	property color buttonColor: "#1e1e1e"
	property color buttonHoverColor: "#3700b3"
	default property list<WLogoutButton> buttons

	model: Quickshell.screens
	PanelWindow {
		property var modelData
		screen: modelData
		// TODO: `Config.wLogout.visible` should not control all subclasses of wlogout
		visible: !Hyprland.isOverlaid && Config.wLogout.visible
		exclusionMode: ExclusionMode.Ignore
		WlrLayershell.layer: WlrLayer.Overlay
		WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
		color: "transparent"

		contentItem {
			focus: true
			Keys.onPressed: event => {
				if (event.key == Qt.Key_Escape) Qt.quit()
				else {
					for (let i = 0; i < buttons.length; i++) {
						let button = buttons[i]
						if (event.key == button.keybind) button.exec()
					}
				}
			}
		}

		anchors {
			top: true
			left: true
			bottom: true
			right: true
		}

		Rectangle {
			color: Config.colors.wLogout.bg
			anchors.fill: parent

			MouseArea {
				anchors.fill: parent
				onClicked: Qt.quit()

				GridLayout {
					anchors.centerIn: parent

					width: parent.width * 0.75
					height: parent.height * 0.75

					columns: 3
					columnSpacing: 0
					rowSpacing: 0

					Repeater {
						model: buttons
						delegate: Rectangle {
							required property WLogoutButton modelData
							Layout.fillWidth: true
							Layout.fillHeight: true

							color: ma.containsMouse ? Config.colors.wLogout.buttonHoverBg : Config.colors.wLogout.buttonBg
							border.color: "black"
							border.width: ma.containsMouse ? 0 : 1

							MouseArea {
								id: ma
								anchors.fill: parent
								hoverEnabled: true
								onClicked: modelData.exec()
							}

							Image {
								id: icon
								anchors.centerIn: parent
								source: Config.iconUrl("wlogout/" + modelData.icon + ".png")
								width: parent.width * 0.25
								height: parent.width * 0.25
							}

							Text {
								anchors {
									top: icon.bottom
									topMargin: 20
									horizontalCenter: parent.horizontalCenter
								}

								text: modelData.text
								font.pointSize: 20
								color: "white"
							}
						}
					}
				}
			}
		}
	}
}
