import QtQuick
import QtQuick3D
import QtQuick3D.Helpers
import "./component"

Window {
	width: 800
	height: 600
	visible: true

	View3D {
		anchors.fill: parent
		environment: SceneEnvironment {
			backgroundMode: SceneEnvironment.Color
			clearColor: "#20242c"
		}

		PerspectiveCamera {
			position: Qt.vector3d(0, 45, 120)
			rotation: Quaternion.fromEulerAngles(-15, 0, 0)
		}

		DirectionalLight {
			brightness: 1
		}

		GeodesicFaceColumnsGpu {
			animateHeights: true
			heightCanvas: geodesicHeightCanvas
		}
	}

	GeodesicHeightCanvas {
		id: geodesicHeightCanvas
		x: -10000
		y: -10000
		animateHeights: true
	}
}
