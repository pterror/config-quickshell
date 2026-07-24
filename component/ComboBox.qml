import QtQuick
import QtQuick.Controls as QQC
import qs

QQC.ComboBox {
	id: root

	implicitHeight: 38
	hoverEnabled: true

	font.family: Config._.font.family
	font.pointSize: Config._.style.widget.fontSize

	contentItem: Text {
		leftPadding: 12
		rightPadding: 30
		text: root.displayText
		color: "#eff7f6"
		verticalAlignment: Text.AlignVCenter
		elide: Text.ElideRight
		font: root.font
	}

	indicator: Text {
		x: root.width - width - 12
		y: root.height / 2 - height / 2
		text: "▾"
		color: "#cbe7f0"
		font: root.font
	}

	background: Rectangle {
		radius: Config._.style.glass.radius
		color: "#14000000"
		border.width: 1
		border.color: root.hovered ? "#50b2f7ef" : "#24ffffff"

		MouseArea {
			enabled: false
			anchors.fill: parent
			cursorShape: Qt.PointingHandCursor
		}
	}

	popup: QQC.Popup {
		y: root.height + 4
		width: root.width
		padding: 4

		contentItem: ListView {
			clip: true
			implicitHeight: contentHeight
			model: root.popup.visible ? root.delegateModel : null
			currentIndex: root.highlightedIndex
		}

		background: Rectangle {
			radius: Config._.style.glass.radius
			color: "#18131d26"
			border.width: 1
			border.color: "#2effffff"
		}
	}

	delegate: QQC.ItemDelegate {
		required property var modelData
		required property int index
		width: root.width - 8

		contentItem: Text {
			text: parent.modelData
			color: "#eff7f6"
			verticalAlignment: Text.AlignVCenter
			font: root.font
		}

		background: Rectangle {
			radius: Config._.style.glass.radius
			color: parent.highlighted ? "#2a7bdff2" : "transparent"
		}
	}
}
