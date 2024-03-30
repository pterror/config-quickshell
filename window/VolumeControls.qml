import Quickshell
import Quickshell.Wayland
import "../component"
import "../input"
import ".."

PanelWindow {
	color: "transparent"
	WlrLayershell.namespace: "shell:volumecontrols"
	width: content.implicitWidth
	height: content.implicitHeight

	RowLayout2 {
		autoSize: true
		id: content

    VProgressBar {
      fraction: 1
    }

    VProgressBar {
      fraction: 1
    }
  }
}
