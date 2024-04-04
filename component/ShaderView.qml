/*
 *
 *  Shader Wallpaper
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
import ".."

Rectangle {
	id: root
	property var config: Config.shaderWallpaper
	anchors.fill: parent
	ShaderEffect {
		anchors.fill: parent
		id: shader
		property vector3d iResolution: Qt.vector3d(width, height, 0)
		property real iTime: 0
		property list<real> iChannelTime: [0., 0., 0., 0.]
		property real iFrameRate: 60
		property real iTimeDelta: 1 / iFrameRate
		property real iSampleRate: 1
		property int iFrame: 10
		property vector4d iMouse: Qt.vector4d(0., 0., 0., 0.)
		property vector4d iDate
		property Image iChannel0: Image {
			source: Config.shaderWallpaper.channel0
			visible: false
		}
		property Image iChannel1: Image {
			source: Config.shaderWallpaper.channel1
			visible: false
		}
		property Image iChannel2: Image {
			source: Config.shaderWallpaper.channel2
			visible: false
		}
		property Image iChannel3: Image {
			source: Config.shaderWallpaper.channel3
			visible: false
		}
		
		readonly property vector3d defaultResolution: Qt.vector3d(width, height, width / height)
		property list<vector3d> iChannelResolution: [
			Qt.vector3d(iChannel0.width, iChannel0.height, iChannel0.width / iChannel0.height),
			Qt.vector3d(iChannel1.width, iChannel1.height, iChannel1.width / iChannel1.height),
			Qt.vector3d(iChannel2.width, iChannel2.height, iChannel2.width / iChannel2.height),
			Qt.vector3d(iChannel3.width, iChannel3.height, iChannel3.width / iChannel3.height),
		]

		fragmentShader: "../dep/shader-wallpaper/package/contents/ui/Shaders6/" + Config.shaderWallpaper.shader + ".frag.qsb"
	}


	Component.onCompleted: Qt.createQmlObject(
		`import QtQuick
		MouseArea {
			id: mouseTrackingArea
			propagateComposedEvents: true
			preventStealing: true
			enabled: true
			anchors.fill: parent
			hoverEnabled: true
			onPositionChanged: {
				if (!root.config.mouse) return
				shader.iMouse.x = mouseX * root.config.mouseSpeedBias
				shader.iMouse.y = -mouseY * root.config.mouseSpeedBias
			}
			onClicked: {
				if (!Config.wallpaper.mouse) return
				shader.iMouse.z = mouseX
				shader.iMouse.w = mouseY
			}
		}`,
		root,
		"mouseTrackerArea"
	)

	Timer {
		id: timer1
		running: true
		triggeredOnStart: true
		interval: 16
		repeat: true
		onTriggered: {
			var now = new Date()
			var year = now.getFullYear()
			var month = now.getMonth() +1
			var day = now.getDate()
			var hour = now.getHours()
			var minute = now.getMinutes()
			var second = now.getSeconds()
			var now = new Date()
			var startOfDay = new Date(now.getFullYear(), now.getMonth(), now.getDate(), 0, 0, 0)
			var secondsSinceMidnight = (now - startOfDay) / 1000
			shader.iTime += shader.iTimeDelta * (Config.shaderWallpaper.speed || 1.0)
			shader.iChannelTime = [shader.iTime, shader.iTime, shader.iTime, shader.iTime]
			shader.iFrame += 1
			shader.iDate = Qt.vector4d(0., 0., 0., secondsSinceMidnight)
		}
	}
}
