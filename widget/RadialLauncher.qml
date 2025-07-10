import Quickshell
import Quickshell.Io
// import Qti.ApplicationDatabase
import QtQuick
import QtQuick.Controls
import qs.component
import qs

Item {
	id: root
	property int radius: 320
	implicitWidth: radius * 2
	implicitHeight: radius * 2
	property int iconSize: 64
	property int iconMaxSize: 128
	property var scaleByProximity: p => Math.max(0, Math.min(1, (3 - p) / 3))
	property int iconCenterRadius: radius - (iconMaxSize / 2) - Config._.style.button.margins
	property int minimumGap: 16
	property int count: Math.min(
		2 * Math.PI * iconCenterRadius / (iconSize + minimumGap),
		ApplicationDatabase.applications.length
	)
	property real angle: 360 / count
	property var mouseAngle: undefined

	Process {
		id: process; manageLifetime: false
		property string appCommand: ""
		command: ["sh", "-c", "nohup " + appCommand + " >/dev/null 2>&1 & disown"]
	}

	MouseArea {
		anchors.fill: parent
		hoverEnabled: true
		propagateComposedEvents: true
		onPositionChanged: event => {
			const x = mouseX - radius
			const y = mouseY - radius
			mouseAngle = (450 - Math.atan2(-y, x) * 180 / Math.PI) % 360
		}
		onExited: mouseAngle = undefined
	}

	Repeater {
		model: root.count

		HoverIcon {
			required property var modelData
			property var appInfo: ApplicationDatabase.applications[modelData]
			property real proximity: {
				const mousePos = (mouseAngle ?? 0) / 360 * root.count
				return Math.min(Math.abs(mousePos - modelData), Math.abs(mousePos - root.count - modelData))
			}
			property real scale: scaleByProximity(proximity)
			source: Quickshell.iconPath(appInfo.icon)
			size: {
				if (iconMaxSize === iconSize || mouseAngle === undefined) return iconSize
				const ratio = scaleByProximity(proximity)
				return iconMaxSize * ratio + iconSize * (1 - ratio)
			}
			maxSize: iconMaxSize
			x: root.radius + Math.cos((modelData / root.count - 0.25) * 2 * Math.PI) * iconCenterRadius - size / 2
			y: root.radius + Math.sin((modelData / root.count - 0.25) * 2 * Math.PI) * iconCenterRadius - size / 2
			toolTip: appInfo.name
			onClicked: {
				if (!appInfo.exec) return
				process.appCommand = appInfo.exec.replace(" %U", "")
				process.running = false // this is safe because `manageLifetime` is false
				process.running = true
			}

			Connections {
				target: mouseArea
				function onPositionChanged(event) {
					const x = mouseArea.mapToItem(root, mouseArea.mouseX, 0).x - radius
					const y = mouseArea.mapToItem(root, 0, mouseArea.mouseY).y - radius
					mouseAngle = (450 - Math.atan2(-y, x) * 180 / Math.PI) % 360
				}
			}
		}
	}
}
