import QtQuick
import Quickshell.Io

Item {
	id: root
	required property string command
	required property string text
	required property string icon
	property var keybind: null
	Process { id: process;
	//manageLifetime: false;
	command: ["sh", "-c", root.command] }
	function exec() { process.running = true; Qt.quit() }
}
