import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.io
import qs.component
import qs

RowLayout {
	id: root
  property alias model: repeater.model
	required property Component sourceComponent

	Repeater {
    id: repeater

		Loader {
      id: loader
			required property var modelData
      sourceComponent: root.sourceComponent
		}
	}
}
