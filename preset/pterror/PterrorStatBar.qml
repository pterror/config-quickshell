import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.io
import qs.component
import qs.widget
import qs

// Frosted-glass top bar: translucent tint + hairline border (config/ConfigBase.qml
// `style.glass`). No backdrop blur (deliberately not used). Flush against the
// screen's top/left/right edges, so there's also no surface headroom for a drop
// shadow here.

PanelWindow {
	id: root
	anchors { left: true; right: true; top: true }
	implicitHeight: 32 // TODO[broken]: Config._.style.hBar.height
	color: "transparent"
	Component.onCompleted: {
		if (this.WlrLayershell) {
			this.WlrLayershell.layer = WlrLayer.Bottom
			this.WlrLayershell.namespace = "shell:bar"
		}
	}

	Rectangle {
		id: barRect
		anchors.fill: parent
		color: Config._.style.bar.bg
		radius: Config._.style.hBar.radius
		border.color: Config._.style.bar.outline
		border.width: Config._.style.hBar.border

		RowLayout {
			implicitHeight: parent.height
			anchors.left: parent.left

			Text {
				function n(n) { return String(n).padStart(2, "0") }
				text: " " + n(Time.time.getHours()) + ":" + n(Time.time.getMinutes()) + ":" + n(Time.time.getSeconds()) + " " + n(Time.time.getDate()) + "/" + n(Time.time.getMonth() + 1)
			}
		}

		RowLayout {
			implicitHeight: parent.height
			anchors.centerIn: parent

			Text { text: Config.services.compositor.activeWindow.title.normalize("NFKC").toLowerCase() }
		}

		RowLayout {
			implicitHeight: parent.height
			anchors.right: parent.right

			TrayStatus {}

			HoverItem {
				onClicked: {
					if (!visualizerShowcaseLoader.active) visualizerShowcaseLoader.loading = true
					else visualizerShowcaseLoader.active = false
				}

				Text {
					id: visualizerText
					text: "viz"

					LazyLoader {
						id: visualizerShowcaseLoader
						PopupWindow {
							id: visualizerPopup
							anchor.window: root
							anchor.rect.x: (root.screen.width - visualizerPopup.implicitWidth) / 2
							anchor.rect.y: (root.screen.height - visualizerPopup.implicitHeight) / 2
							extraGrabWindows: [root]
							implicitWidth: Math.min(1600, root.screen.width - 160)
							implicitHeight: Math.min(1100, root.screen.height - 160)
							visible: true
							// Keep the loader's active/loading toggle in sync when
							// HyprlandFocusGrab closes this popup via an outside click
							// (see PopupWindow.dismissed doc comment).
							onDismissed: Qt.callLater(() => visualizerShowcaseLoader.active = false)

							VisualizerShowcaseContent {
								anchors.fill: parent
								onCloseRequested: visualizerShowcaseLoader.active = false
							}
						}
					}
				}
			}

			HoverItem {
				onClicked: Config._.workspacesOverview.visible = !Config._.workspacesOverview.visible
				RowRepeater {
					model: HyprlandWorkspacesModel { count: 9 }
					sourceComponent: WorkspaceExpandingDot {}
				}
			}
		}
	}
}
