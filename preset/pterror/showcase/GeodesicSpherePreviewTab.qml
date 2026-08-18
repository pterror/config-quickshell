import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.component
import qs.io
import qs

Item {
	id: root

	readonly property var modeNames: ["shader procedural", "cpu texture"]
	readonly property var heightModeNames: [
		"constant",
		"traveling waves",
		"interference",
		"latitude bands",
		"spiral",
		"pulse",
		"craters",
		"ripple mesh"
	]
	readonly property var colorModeNames: [
		"grayscale",
		"monochrome glow",
		"heatmap",
		"aurora",
		"contour",
		"polar",
		"prism",
		"sunset bands"
	]
	readonly property var paletteDefs: [
		{ label: "ice", primary: "#7bdff2", secondary: "#b2f7ef", accent: "#eff7f6" },
		{ label: "amber", primary: "#ffd166", secondary: "#f4a261", accent: "#fff1b6" },
		{ label: "rose", primary: "#ff6b6b", secondary: "#f06595", accent: "#ffe3ec" },
		{ label: "mint", primary: "#4ecdc4", secondary: "#74c69d", accent: "#d8f3dc" },
		{ label: "neon", primary: "#80ed99", secondary: "#00f5d4", accent: "#caffbf" }
	]

	property int renderMode: 0
	property bool animate: true
	property bool showCoreSphere: true
	property bool autoOrbit: true
	property int frequency: 10
	property int pendingFrequency: frequency
	property real radius: 24
	property real baseHeight: 0.25
	property real heightScale: 9
	property int heightMode: 1
	property int colorMode: 3
	property int paletteIndex: 0
	property real amplitude: 1
	property real speed: 1
	property real frequencyA: 6.5
	property real frequencyB: 4.0
	property real twist: 2.3
	property real bias: 0
	property real banding: 7
	property real colorMix: 0.55
	property real roughness: 0.82
	property real specularAmount: 0.12
	property real glow: 0.2
	property real globeRotationDegrees: 0
	property int shellPid: 0
	property real processCpuSingleCorePercent: 0
	property real processRssMiB: 0
	property real _lastProcTicks: 0
	property real _lastTotalTicks: 0

	readonly property var palette: paletteDefs[paletteIndex % paletteDefs.length]
	readonly property int displayedFrequency: frequencySlider.pressed ? pendingFrequency : frequency
	readonly property int faceCount: 20 * displayedFrequency * displayedFrequency
	readonly property int renderedTriangleCount: faceCount * 7
	readonly property int uploadBytesPerFrame: geodesicHeightTexture.textureWidth * geodesicHeightTexture.textureHeight
	readonly property real uploadKiBPerFrame: uploadBytesPerFrame / 1024
	readonly property real uploadMiBPerSecond: animate && renderMode === 1 ? uploadBytesPerFrame * 60 / (1024 * 1024) : 0

	function metricText(value, digits) {
		return Number(value).toFixed(digits)
	}

	function extractProcTicks(text) {
		if (!text)
			return 0
		const match = text.match(/^[^(]+\([^)]*\)\s+\S+\s+\S+(?:\s+\S+){10}\s+(\d+)\s+(\d+)/)
		if (!match)
			return 0
		return Number(match[1]) + Number(match[2])
	}

	function extractTotalTicks(text) {
		if (!text)
			return 0
		const firstLine = text.match(/^cpu\s+(.+)$/m)
		if (!firstLine)
			return 0
		return firstLine[1].trim().split(/\s+/).reduce((sum, part) => sum + Number(part || 0), 0)
	}

	function updateProcessMetrics(procStatText, procStatusText, cpuStatText) {
		if (!shellPid)
			return
		const procTicks = extractProcTicks(procStatText)
		const totalTicks = extractTotalTicks(cpuStatText)
		const procDelta = procTicks - _lastProcTicks
		const totalDelta = totalTicks - _lastTotalTicks
		if (_lastProcTicks > 0 && _lastTotalTicks > 0 && totalDelta > 0)
			processCpuSingleCorePercent = Math.max(0, (procDelta / totalDelta) * CPUInfo.cpuCount * 100)
		_lastProcTicks = procTicks
		_lastTotalTicks = totalTicks
		const rssMatch = procStatusText.match(/VmRSS:\s+(\d+)/)
		processRssMiB = Number(rssMatch?.[1] ?? 0) / 1024
	}

	Component.onCompleted: {
		pidProcess.running = true
	}

	Process {
		id: pidProcess
		command: ["bash", "-lc", "printf '%s\\n' \"$PPID\""]
		stdout: SplitParser {
			onRead: data => {
				root.shellPid = Number(String(data).trim()) || 0
			}
		}
	}

	Process {
		id: metricSampleProcess
		command: root.shellPid ? [
			"bash",
			"-lc",
			`cat /proc/${root.shellPid}/stat; printf '\\n__STATUS__\\n'; cat /proc/${root.shellPid}/status; printf '\\n__CPU__\\n'; head -n 1 /proc/stat`
		] : []
		stdout: SplitParser {
			splitMarker: ""
			onRead: data => {
				const text = String(data)
				const parts = text.split("\n__STATUS__\n")
				if (parts.length !== 2)
					return
				const procStatText = parts[0]
				const statusAndCpu = parts[1].split("\n__CPU__\n")
				if (statusAndCpu.length !== 2)
					return
				root.updateProcessMetrics(procStatText, statusAndCpu[0], statusAndCpu[1])
			}
		}
	}

	Timer {
		id: frequencyDebounceTimer
		interval: 140
		repeat: false
		onTriggered: root.frequency = root.pendingFrequency
	}

	Timer {
		interval: 1000
		running: true
		repeat: true
		triggeredOnStart: true
		onTriggered: {
			if (!root.shellPid)
				return
			metricSampleProcess.running = true
		}
	}

	Timer {
		interval: 16
		running: root.autoOrbit
		repeat: true
		onTriggered: root.globeRotationDegrees = (root.globeRotationDegrees + 0.46) % 360
	}

	component SectionCard: Rectangle {
		id: sectionCard
		default property alias content: body.data
		property string title: ""
		Layout.fillWidth: true
		radius: Config._.style.glass.radius
		color: "#18ffffff"
		border.width: 1
		border.color: "#33ffffff"
		implicitHeight: body.implicitHeight + 28

		ColumnLayout {
			id: body
			anchors.fill: parent
			anchors.margins: 14
			spacing: 10

			Text {
				text: sectionCard.title
				color: "white"
				font.bold: true
			}
		}
	}

	component MetricTile: Rectangle {
		id: metricTile
		property string label: ""
		property string value: ""
		Layout.fillWidth: true
		Layout.preferredHeight: 72
		radius: Config._.style.glass.radius
		color: "#12000000"
		border.width: 1
		border.color: "#24ffffff"

		Column {
			anchors.fill: parent
			anchors.margins: 12
			spacing: 4

			Text {
				text: metricTile.label
				color: "#bfe8f7ff"
			}

			Text {
				text: metricTile.value
				color: "white"
				font.bold: true
			}
		}
	}

	component LabeledSlider: Item {
		id: labeledSlider
		property string label: ""
		property real from: 0
		property real to: 1
		property real stepSize: 0.1
		property int decimals: 2
		property real value: 0
		property bool pressed: slider.pressed
		signal valueEdited(real value)
		implicitWidth: 176
		implicitHeight: 82

		ColumnLayout {
			anchors.fill: parent
			spacing: 6

			RowLayout {
				Layout.fillWidth: true

				Text {
					text: labeledSlider.label
					color: "white"
				}

				Item { Layout.fillWidth: true }

				Text {
					text: Number(labeledSlider.value).toFixed(labeledSlider.decimals)
					color: "#cbe7f0"
				}
			}

			Slider {
				id: slider
				Layout.fillWidth: true
				Layout.alignment: Qt.AlignVCenter
				from: labeledSlider.from
				to: labeledSlider.to
				stepSize: labeledSlider.stepSize
				value: labeledSlider.value
				onMoved: function() { labeledSlider.valueEdited(slider.value) }
			}
		}
	}

	component LabeledCombo: ColumnLayout {
		id: labeledCombo
		property string label: ""
		property var model: []
		property int currentIndex: 0
		signal indexEdited(int index)
		spacing: 6

		Text {
			text: labeledCombo.label
			color: "white"
		}

		ComboBox {
			id: combo
			Layout.fillWidth: true
			model: labeledCombo.model
			currentIndex: labeledCombo.currentIndex
			onActivated: labeledCombo.indexEdited(currentIndex)
		}
	}

	component LabeledSwitch: RowLayout {
		id: labeledSwitch
		property string label: ""
		property bool checked: false
		signal toggled(bool checked)
		Layout.fillWidth: true

		Text {
			text: labeledSwitch.label
			color: "white"
		}

		Item { Layout.fillWidth: true }

		Switch {
			id: themedSwitch
			Layout.alignment: Qt.AlignVCenter
			checked: labeledSwitch.checked
			onToggled: labeledSwitch.toggled(checked)
		}
	}

	Rectangle {
		anchors.fill: parent
		color: "transparent"

		RowLayout {
			anchors.fill: parent
			anchors.margins: 20
			spacing: 18

			Rectangle {
				Layout.fillWidth: true
				Layout.fillHeight: true
				Layout.preferredWidth: 980
				radius: Config._.style.glass.radius
				color: "#13000000"
				border.width: 1
				border.color: "#30ffffff"

				ColumnLayout {
					anchors.fill: parent
					anchors.margins: 16
					spacing: 12

					RowLayout {
						Layout.fillWidth: true

						Text {
							text: "geodesic sphere preview"
							color: "white"
							font.bold: true
						}

						Item { Layout.fillWidth: true }

						Text {
							text: `${root.modeNames[root.renderMode]}  |  f=${root.displayedFrequency}  |  ${root.faceCount} faces`
							color: "#d2eff8"
						}
					}

					GridLayout {
						Layout.fillWidth: true
						columns: 4
						columnSpacing: 12
						rowSpacing: 12

						MetricTile { label: "quickshell cpu"; value: `${root.metricText(root.processCpuSingleCorePercent, 1)}% of one core` }
						MetricTile { label: "quickshell rss"; value: `${root.metricText(root.processRssMiB, 1)} MiB` }
						MetricTile { label: "mesh density"; value: `${root.renderedTriangleCount} render tris` }
						MetricTile { label: "cpu upload"; value: root.renderMode === 1 ? `${root.metricText(root.uploadKiBPerFrame, 1)} KiB/frame` : "off in shader mode" }
					}

					Viewer3D {
						id: globeView
						Layout.fillWidth: true
						Layout.fillHeight: true
						clearColor: "#00000000"
						cameraX: 0
						cameraY: 0
						cameraZ: 110
						orbitDistance: 110
						panSpringRadius: 100
						orbitTarget: Qt.vector3d(0, 0, 0)

						GeodesicFaceColumnsGpu {
							id: globe
							eulerRotation.y: root.globeRotationDegrees
							radius: root.radius
							frequency: root.frequency
							baseHeight: root.baseHeight
							heightScale: root.heightScale
							showCoreSphere: root.showCoreSphere
							sphereColor: "#193348"
							columnColor: root.palette.primary
							secondaryColor: root.palette.secondary
							accentColor: root.palette.accent
							animateHeights: root.animate
							renderMode: root.renderMode
							heightMode: root.heightMode
							colorMode: root.colorMode
							amplitude: root.amplitude
							speed: root.speed
							frequencyA: root.frequencyA
							frequencyB: root.frequencyB
							twist: root.twist
							bias: root.bias
							banding: root.banding
							colorMix: root.colorMix
							roughnessAmount: root.roughness
							specularAmount: root.specularAmount
							glowAmount: root.glow
							heightTextureData: geodesicHeightTexture
						}
					}
				}
			}

			Rectangle {
				Layout.preferredWidth: 460
				Layout.fillHeight: true
				radius: Config._.style.glass.radius
				color: "#0f000000"
				border.width: 1
				border.color: "#20ffffff"
				z: 10

				Flickable {
					id: controlsFlickable
					anchors.fill: parent
					anchors.margins: 8
					clip: true
					contentWidth: width
					contentHeight: controlsColumn.implicitHeight
					boundsBehavior: Flickable.StopAtBounds
					acceptedButtons: Qt.NoButton

					ColumnLayout {
						id: controlsColumn
						width: controlsFlickable.width
						spacing: 14

						SectionCard {
							title: "render path"

							LabeledCombo {
								Layout.fillWidth: true
								label: "mode"
								model: root.modeNames
								currentIndex: root.renderMode
								onIndexEdited: function(index) { root.renderMode = index }
							}

						LabeledCombo {
							Layout.fillWidth: true
							label: "height pattern"
							model: root.heightModeNames
							currentIndex: root.heightMode
							onIndexEdited: function(index) { root.heightMode = index }
						}

						LabeledCombo {
							Layout.fillWidth: true
							label: "color algorithm"
							model: root.colorModeNames
							currentIndex: root.colorMode
							onIndexEdited: function(index) { root.colorMode = index }
						}

						LabeledCombo {
							Layout.fillWidth: true
							label: "palette"
							model: root.paletteDefs.map(p => p.label)
							currentIndex: root.paletteIndex
							onIndexEdited: function(index) { root.paletteIndex = index }
						}

						LabeledSwitch {
							label: "animate"
							checked: root.animate
							onToggled: function(checked) { root.animate = checked }
						}

						LabeledSwitch {
							label: "show core sphere"
							checked: root.showCoreSphere
							onToggled: function(checked) { root.showCoreSphere = checked }
						}

						LabeledSwitch {
							label: "auto orbit"
							checked: root.autoOrbit
							onToggled: function(checked) { root.autoOrbit = checked }
						}
					}

						SectionCard {
							title: "geometry"

							GridLayout {
								Layout.fillWidth: true
								columns: 2
								columnSpacing: 10
								rowSpacing: 8

								LabeledSlider {
									id: frequencySlider
									Layout.fillWidth: true
									label: "frequency"
									from: 1
									to: 64
									stepSize: 1
									decimals: 0
									value: root.pendingFrequency
									onValueEdited: function(value) {
										root.pendingFrequency = Math.round(value)
										frequencyDebounceTimer.restart()
									}
								}

								LabeledSlider {
									id: radiusSlider
									Layout.fillWidth: true
									label: "radius"
									from: 8
									to: 40
									stepSize: 0.5
									decimals: 1
									value: root.radius
									onValueEdited: function(value) { root.radius = value }
								}

								LabeledSlider {
									id: baseHeightSlider
									Layout.fillWidth: true
									label: "base height"
									from: 0
									to: 2
									stepSize: 0.05
									decimals: 2
									value: root.baseHeight
									onValueEdited: function(value) { root.baseHeight = value }
								}

								LabeledSlider {
									id: heightScaleSlider
									Layout.fillWidth: true
									label: "height scale"
									from: 0
									to: 18
									stepSize: 0.25
									decimals: 2
									value: root.heightScale
									onValueEdited: function(value) { root.heightScale = value }
								}
							}
						}

						SectionCard {
							title: "height shader"

							GridLayout {
								Layout.fillWidth: true
								columns: 2
								columnSpacing: 10
								rowSpacing: 8

								LabeledSlider {
									id: amplitudeSlider
									Layout.fillWidth: true
									label: "amplitude"
									from: 0
									to: 2
									stepSize: 0.05
									value: root.amplitude
									onValueEdited: function(value) { root.amplitude = value }
								}

								LabeledSlider {
									id: speedSlider
									Layout.fillWidth: true
									label: "speed"
									from: 0
									to: 4
									stepSize: 0.05
									value: root.speed
									onValueEdited: function(value) { root.speed = value }
								}

								LabeledSlider {
									id: frequencyASlider
									Layout.fillWidth: true
									label: "freq a"
									from: 0
									to: 14
									stepSize: 0.1
									value: root.frequencyA
									onValueEdited: function(value) { root.frequencyA = value }
								}

								LabeledSlider {
									id: frequencyBSlider
									Layout.fillWidth: true
									label: "freq b"
									from: 0
									to: 14
									stepSize: 0.1
									value: root.frequencyB
									onValueEdited: function(value) { root.frequencyB = value }
								}

								LabeledSlider {
									id: twistSlider
									Layout.fillWidth: true
									label: "twist"
									from: 0
									to: 8
									stepSize: 0.05
									value: root.twist
									onValueEdited: function(value) { root.twist = value }
								}

								LabeledSlider {
									id: biasSlider
									Layout.fillWidth: true
									label: "bias"
									from: -1
									to: 1
									stepSize: 0.05
									value: root.bias
									onValueEdited: function(value) { root.bias = value }
								}
							}
						}

						SectionCard {
							title: "surface / color"

							GridLayout {
								Layout.fillWidth: true
								columns: 2
								columnSpacing: 10
								rowSpacing: 8

								LabeledSlider {
									id: bandingSlider
									Layout.fillWidth: true
									label: "banding"
									from: 1
									to: 18
									stepSize: 0.25
									value: root.banding
									onValueEdited: function(value) { root.banding = value }
								}

								LabeledSlider {
									id: colorMixSlider
									Layout.fillWidth: true
									label: "color mix"
									from: 0
									to: 1
									stepSize: 0.02
									value: root.colorMix
									onValueEdited: function(value) { root.colorMix = value }
								}

								LabeledSlider {
									id: roughnessSlider
									Layout.fillWidth: true
									label: "roughness"
									from: 0
									to: 1
									stepSize: 0.02
									value: root.roughness
									onValueEdited: function(value) { root.roughness = value }
								}

								LabeledSlider {
									id: specularSlider
									Layout.fillWidth: true
									label: "specular"
									from: 0
									to: 1
									stepSize: 0.02
									value: root.specularAmount
									onValueEdited: function(value) { root.specularAmount = value }
								}

								LabeledSlider {
									id: glowSlider
									Layout.fillWidth: true
									label: "glow"
									from: 0
									to: 1
									stepSize: 0.02
									value: root.glow
									onValueEdited: function(value) { root.glow = value }
								}
							}
						}

						SectionCard {
							title: "perf notes"

							Text {
								Layout.fillWidth: true
								wrapMode: Text.WordWrap
								color: "#d8eef6"
								text: root.renderMode === 1
									? `cpu mode uploads an R8 texture each frame: ~${root.metricText(root.uploadKiBPerFrame, 1)} KiB/frame, ~${root.metricText(root.uploadMiBPerSecond, 2)} MiB/s at 60 fps.`
									: "shader mode keeps the mesh static and generates heights/colors entirely in the material; CPU work should mostly be scene bookkeeping."
							}

							Text {
								Layout.fillWidth: true
								wrapMode: Text.WordWrap
								color: "#d8eef6"
								text: `process metrics target pid ${root.shellPid || "?"} and report quickshell CPU as a percentage of one logical core plus resident memory from /proc.`
							}
						}
					}
				}
			}
		}
	}

	GeodesicHeightTexture {
		id: geodesicHeightTexture
		sampleCount: root.faceCount
		animateHeights: root.animate && root.renderMode === 1
		heightMode: root.heightMode
		amplitude: root.amplitude
		speed: root.speed
		frequencyA: root.frequencyA
		frequencyB: root.frequencyB
		twist: root.twist
		bias: root.bias
	}
}
