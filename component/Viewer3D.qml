import QtQuick
import QtQuick3D
import QtQuick3D.Helpers

View3D {
	anchors.fill: parent
	property alias clearColor: environment.clearColor
	property alias cameraX: camera.x
	property alias cameraY: camera.y
	property alias cameraZ: camera.z
	property alias cameraRotation: camera.rotation
	environment: SceneEnvironment {
		id: environment
		backgroundMode: SceneEnvironment.Color
		clearColor: "#789"
	}

	PerspectiveCamera {
		id: camera
	}

	DirectionalLight {
		brightness: 0.2
		ambientColor: "#c0c0c0"
	}

	// note: does not work on layershells
	WasdController {
		controlledObject: camera
	}
}
