import QtQuick
import QtQuick.Layouts
import qs.component
import qs

// Tab strip up top, selected tab's content below, crossfaded on switch.
//
// `tabs` is a plain list of { label: string, component: Component } — each
// component is lazy-loaded on first selection and then stays instantiated,
// so revisiting a tab preserves its state (scroll position, animations, etc).
Rectangle {
	id: root

	required property list<var> tabs // [{ label: string, component: Component }]
	property int currentIndex: 0
	property int animationDuration: Config._.style.button.animationDuration

	color: Config._.debugFlags.debugRectangles ? "#20ff0000" : "transparent"
	border.color: Config._.debugFlags.debugRectangles ? "#80ff0000" : "transparent"
	border.width: Config._.debugFlags.debugRectangles ? 1 : 0

	// Content area has no natural size of its own — callers size the
	// TabbedView explicitly (Layout.fillWidth/fillHeight, or fixed
	// width/height) the same way they would any other container.
	implicitWidth: strip.implicitWidth
	implicitHeight: strip.implicitHeight

	ColumnLayout {
		anchors.fill: parent
		spacing: Config._.style.widget.margins

		RowLayout {
			id: strip
			Layout.fillWidth: true
			spacing: 4

			Item { Layout.fillWidth: true }

			Repeater {
				model: root.tabs

				Rectangle {
					id: tabButton
					required property var modelData
					required property int index
					readonly property bool selected: index === root.currentIndex
					readonly property bool hovered: mouseArea.containsMouse

					Layout.preferredWidth: label.implicitWidth + Config._.style.button.margins * 5
					implicitHeight: label.implicitHeight + Config._.style.button.margins * 3
					radius: Config._.style.button.radius
					border.width: Config._.style.button.border
					border.color: Config._.style.button.outline
					color: tabButton.selected
						? Config._.style.button.accent
						: (tabButton.hovered ? Config._.style.button.hoverBg : Config._.style.button.bg)

					Behavior on color { PropertyAnimation { duration: root.animationDuration } }

					Text {
						id: label
						anchors.centerIn: parent
						text: tabButton.modelData.label
						color: Config._.style.button.fg
						font.bold: tabButton.selected
					}

					MouseArea {
						id: mouseArea
						anchors.fill: parent
						hoverEnabled: true
						cursorShape: Qt.PointingHandCursor
						onClicked: root.currentIndex = tabButton.index
					}
				}
			}

			Item { Layout.fillWidth: true }
		}

		Item {
			id: contentArea
			Layout.fillWidth: true
			Layout.fillHeight: true
			clip: true

			Repeater {
				model: root.tabs

				Loader {
					id: tabLoader
					required property var modelData
					required property int index
					readonly property bool isCurrent: tabLoader.index === root.currentIndex
					// Once loaded, stays loaded — flips true the first time this
					// tab becomes current and never flips back.
					property bool everLoaded: false

					anchors.fill: parent
					active: tabLoader.isCurrent || tabLoader.everLoaded
					sourceComponent: tabLoader.modelData.component
					// Only the current tab accepts input; the rest are inert
					// while they crossfade out.
					enabled: tabLoader.isCurrent
					visible: opacity > 0
					opacity: tabLoader.isCurrent ? 1 : 0

					onIsCurrentChanged: if (tabLoader.isCurrent) tabLoader.everLoaded = true
					Component.onCompleted: if (tabLoader.isCurrent) tabLoader.everLoaded = true

				}
			}
		}
	}
}
