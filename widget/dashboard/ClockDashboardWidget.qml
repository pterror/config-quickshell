import QtQuick
import qs.io
import qs.component
import qs

// Reference widget for `window/WidgetOverlay.qml`'s plugin discovery: any `.qml` file
// dropped into this directory is picked up automatically. `widgetId`/`index` are assigned
// by the overlay after load — don't set them here.
DashboardWidget {
	contentMargins: 4
	implicitWidth: 188
	implicitHeight: 72

	Text {
		anchors.centerIn: parent
		color: Config._.style.panel.fg
		font.family: Config._.font.family
		font.pointSize: 22
		text: Config.formatTime(Time.time, Locale.ShortFormat)
	}
}
