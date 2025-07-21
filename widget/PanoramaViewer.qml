/*  Shader Wallpaper
 *  Copyright (C) 2020 @y4my4my4m | github.com/y4my4my4m
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <https://www.gnu.org/licenses/>.
 *
 *  This software uses some of the QML code from JaredTao/jared2020@163.com's ToyShader for Android.
 *  See: https://github.com/jaredtao/TaoShaderToy/
 *
 *  Thanks to: Rog131 <samrog131@hotmail.com>, adhe <adhemarks2@gmail.com>
 *  for their work on the SmartVideoWallpaper plugin, I've used this as a reference for
 *  pausing the shader when fullscreen/maximed or when resources are busy
 *
 *  Thanks to github.com/simons-public for his contributions
 */
import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import qs.component
import qs

Rectangle {
	id: root
	color: "transparent"
	anchors.fill: parent
	width: 100
	height: 100
	property var config: Config._.wallpapers.panorama
	property real fovDegrees: config.fov
	property real fov: fovDegrees * Math.PI / 180
	property bool playing: false
	property bool moving: !mouseArea.containsPress
	property real yawVelocity: Math.PI / 1800
	property alias source: shaderImage.source
	property alias velocityX: momentumAnimationX.velocity
	property alias velocityY: momentumAnimationY.velocity

	MomentumAnimation { id: momentumAnimationX }
	MomentumAnimation { id: momentumAnimationY }

	function impulse(dx: real, dy: real) {
		momentumAnimationX.impulse(dx)
		momentumAnimationY.impulse(dy)
	}

	ShaderEffect {
		id: shader
		anchors.fill: parent
		blending: false
		property vector3d iResolution: Qt.vector3d(width, height, width / height)
		property real iYaw: 0
		property real iPitch: 0
		property real iFov: root.fov / (mouseArea.pressedButtons & Qt.RightButton ? config.rightClickZoom : 1)
		Behavior on iFov { SmoothedAnimation { velocity: -1; duration: config.fovAnimationDuration } }
		property Image iChannel0: Image {
			id: shaderImage
			visible: false
		}

		fragmentShader: "../shader/hdri.frag.qsb"

		FrameAnimation {
			running: true
			onTriggered: {
				if (moving && (momentumAnimationX.velocity !== 0 || momentumAnimationY.velocity !== 0)) {
					const rev = 2 * Math.PI
					const verticalClamp = Math.PI / 2
					shader.iYaw = ((shader.iYaw + momentumAnimationX.velocity / Config._.frameRate) % rev + rev) % rev
					shader.iPitch = Math.max(-verticalClamp, Math.min(verticalClamp, shader.iPitch + momentumAnimationY.velocity / Config._.frameRate))
				} else if (playing) {
					const rev = 2 * Math.PI
					const dx = root.yawVelocity / Config._.frameRate
					shader.iYaw = ((shader.iYaw + dx) % rev + rev) % rev
				}
			}
		}
	}

	MouseArea {
		id: mouseArea
		anchors.fill: parent
		property int prevX: 0
		property int prevY: 0
		acceptedButtons: Qt.LeftButton | Qt.RightButton
		onPressed: event => {
			prevX = event.x
			prevY = event.y
			momentumAnimationX.stop()
			momentumAnimationY.stop()
		}
		onWheel: event => {
			const power = -event.angleDelta.y / 60
			const newFovRaw = root.fovDegrees * Math.pow(config.scrollExponent, power)
			root.fovDegrees = Math.max(config.minFov, Math.min(config.maxFov, newFovRaw))
		}
		onPositionChanged: event => {
			const rev = 2 * Math.PI
			const verticalClamp = Math.PI / 2
			const dx = (event.x - prevX) * shader.iFov / 1080
			const dy = (event.y - prevY) * shader.iFov / 1080
			prevX = event.x
			prevY = event.y
			shader.iYaw = ((shader.iYaw + dx) % rev + rev) % rev
			shader.iPitch = Math.max(-verticalClamp, Math.min(verticalClamp, shader.iPitch + dy))
			momentumAnimationX.impulse(dx * 10)
			momentumAnimationY.impulse(dy * 10)
		}
	}
}
