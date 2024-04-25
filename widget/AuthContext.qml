import Quickshell
import Quickshell.Io
import QtQuick

QtObject {
	property int status: AuthContext.Status.FirstLogin
	property string password
	signal unlocked()

	enum Status {
		FirstLogin,
		Authenticating,
		LoginFailed
	}

	property var pamtester: Process {
		property bool failed: true
		command: ["pamtester", "login", Quickshell.env("USER"), "authenticate"]
		onStarted: this.write(password + "\n")
		stdout: SplitParser {
			// fails go to stderr
			onRead: pamtester.failed = false
		}
		onExited: {
			if (failed) {
				status = AuthContext.Status.LoginFailed
			} else {
				unlocked()
			}
		}
	}

	function tryLogin(password: string) {
		this.password = password
		status = AuthContext.Status.Authenticating
		pamtester.running = true
	}
}
