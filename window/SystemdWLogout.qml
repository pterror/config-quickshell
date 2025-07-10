import QtQuick
import Quickshell
import qs.widget

ShellRoot {
	WLogout {
		WLogoutButton {
			command: "loginctl lock-screen"
			keybind: Qt.Key_K
			text: "Lock"
			icon: "lock"
		}

		WLogoutButton {
			command: "loginctl terminate-user $USER"
			keybind: Qt.Key_E
			text: "Logout"
			icon: "logout"
		}

		WLogoutButton {
			command: "systemctl suspend"
			keybind: Qt.Key_U
			text: "Suspend"
			icon: "suspend"
		}

		WLogoutButton {
			command: "systemctl hibernate"
			keybind: Qt.Key_H
			text: "Hibernate"
			icon: "hibernate"
		}

		WLogoutButton {
			command: "systemctl poweroff"
			keybind: Qt.Key_K
			text: "Shutdown"
			icon: "shutdown"
		}

		WLogoutButton {
			command: "systemctl reboot"
			keybind: Qt.Key_R
			text: "Reboot"
			icon: "reboot"
		}
	}
}
