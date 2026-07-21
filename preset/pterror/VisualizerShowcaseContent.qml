import QtQuick
import QtQuick.Layouts
import qs.component
import qs.widget
import qs

// Plain Item so it can be hosted by either the standalone window (VisualizerShowcase.qml)
// or a popup from PterrorStatBar.qml.
//
// Data is procedurally generated sine waves, not real audio/CPU, so the stacking and
// animation can be eyeballed in isolation; two datasets are reused across widgets that
// share a shape family so the numbers stay comparable across renderings.
Item {
	id: content

	// Emitted on Escape or the close button — hosts decide what "close" means
	// (Qt.quit() for the standalone runner, hiding a popup for the shell).
	signal closeRequested()

	// --- synthetic data -------------------------------------------------

	property real phase: 0
	property int barCount: 24
	property int pointCount: 36

	function wave(count, freq, phaseOffset, amp, baseline) {
		const arr = []
		for (let i = 0; i < count; i++) {
			const t = (i / count) * Math.PI * 2 * freq + content.phase + phaseOffset
			arr.push(baseline + amp * (0.5 + 0.5 * Math.sin(t)))
		}
		return arr
	}

	Timer { interval: 50; running: true; repeat: true; onTriggered: content.phase += 0.06 }

	// Dataset A: drives every bar-shaped stacked visualizer (H/V bars, inwards/outwards
	// radial bars). Three layers, amplitudes chosen so the stack never exceeds ~1.0.
	property list<var> layerA0: content.wave(content.barCount, 3, 0.0, 0.28, 0.05)
	property list<var> layerA1: content.wave(content.barCount, 5, 1.3, 0.22, 0.04)
	property list<var> layerA2: content.wave(content.barCount, 2, 2.6, 0.18, 0.03)
	property var colorsA: ["#ff6b6b", "#4ecdc4", "#ffe66d"]

	// Dataset B: drives every curve-shaped stacked visualizer (H/V smooth, inwards/outwards
	// radial smooth). Same shape as A but a different point count for a smoother curve.
	property list<var> layerB0: content.wave(content.pointCount, 2, 0.0, 0.30, 0.05)
	property list<var> layerB1: content.wave(content.pointCount, 4, 1.7, 0.22, 0.04)
	property list<var> layerB2: content.wave(content.pointCount, 6, 3.1, 0.16, 0.03)
	property var colorsB: ["#ff6b6b", "#4ecdc4", "#ffe66d"]

	// Dataset C: the stacked layers of the centered radial smooth visualizer. Each layer
	// adds mass symmetrically outward and inward around the centerRadius baseline (not two
	// independent rings), so a single value/color list drives both directions at once.
	property list<var> layerC0: content.wave(content.pointCount, 3, 0.4, 0.30, 0.04)
	property list<var> layerC1: content.wave(content.pointCount, 5, 2.2, 0.22, 0.03)
	property var colorsC: ["#ff6b6b", "#4ecdc4"]

	// Fake `input` for the VisualizerBase-derived stacked bar widgets — they only read
	// `input.count` (the actual per-bar values come from the `values` prop), so a plain
	// object with a matching `count` avoids spawning a real Cava process.
	property QtObject fakeInput: QtObject { property int count: content.barCount }

	Shortcut { sequence: "Escape"; onActivated: content.closeRequested() }

	// --- glassmorphism palette ------------------------------------------
	// Mirrors the frosted-glass tokens used in claude-code-hub/ui/index.html:
	// low-alpha white fills, a beveled border (light top/left, dark bottom/right),
	// and a saturated accent for selection state.
	// Light, low-chroma, very translucent tones (rather than the dark widget-wide
	// glass tokens) — this showcase's own background and card fills read too dark
	// against the light desaturated backdrop, so they're overridden locally here.
	// Same e0ffff pale-cyan hue as style.bar.bg/style.barItem.bg, so the cards read
	// as part of the same glass family as the bars and buttons around them.
	readonly property color glassBg: "#26e0ffff"
	readonly property color glassBgHover: "#38e0ffff"
	readonly property color glassBorder: "#2effffff"
	readonly property color glassBorderLight: "#47ffffff"
	readonly property color glassBorderDark: "#40000000"
	readonly property color accent: "#cc3b82f6"
	// Card corner radius: reuse the shared glass token rather than a magic number, so
	// the showcase cards stay visually consistent with every other glass surface.
	readonly property int cardRadius: Config._.style.glass.radius


	// --- visualizer registry ----------------------------------------------
	// One Component per widget instance (each closes over the item-scoped datasets
	// above), paired with display metadata in `visualizerDefs`. Each tab's grid is
	// generated from a filtered slice of this array via Repeater.
	// Each instance renders at `previewOpacity` rather than full opacity: these are
	// glass showcase cards, not the real bar/media-bar visualizers, and at opacity 1
	// the saturated fill colors read as flat and opaque against the frosted-glass
	// card background instead of translucent/glassy.
	readonly property real previewOpacity: 1.0

	Component {
		id: compInwardsRadialBars
		StackedInwardsRadialVisualizerBars {
			outerRadius: 150
			innerRadius: 80
			values: [content.layerA0, content.layerA1, content.layerA2]
			colors: content.colorsA
			opacity: content.previewOpacity
			modulateOpacity: true
			minOpacity: 0.3
			maxOpacity: 0.7
		}
	}
	Component {
		id: compHBars
		StackedHVisualizerBars {
			input: content.fakeInput
			width: 280
			height: 160
			values: [content.layerA0, content.layerA1, content.layerA2]
			colors: content.colorsA
			opacity: content.previewOpacity
			modulateOpacity: true
			minOpacity: 0.3
			maxOpacity: 0.7
		}
	}
	Component {
		id: compVBars
		StackedVVisualizerBars {
			input: content.fakeInput
			width: 160
			height: 280
			values: [content.layerA0, content.layerA1, content.layerA2]
			colors: content.colorsA
			opacity: content.previewOpacity
			modulateOpacity: true
			minOpacity: 0.3
			maxOpacity: 0.7
		}
	}
	Component {
		id: compOutwardsRadialBars
		StackedOutwardsRadialVisualizerBars {
			input: content.fakeInput
			outerRadius: 150
			innerRadius: 80
			values: [content.layerA0, content.layerA1, content.layerA2]
			colors: content.colorsA
			opacity: content.previewOpacity
			modulateOpacity: true
			minOpacity: 0.3
			maxOpacity: 0.7
		}
	}
	Component {
		id: compHSmooth
		StackedHVisualizerSmooth {
			width: 280
			height: 160
			values: [content.layerB0, content.layerB1, content.layerB2]
			colors: content.colorsB
			opacity: content.previewOpacity
		}
	}
	Component {
		id: compVSmooth
		StackedVVisualizerSmooth {
			width: 160
			height: 280
			values: [content.layerB0, content.layerB1, content.layerB2]
			colors: content.colorsB
			opacity: content.previewOpacity
		}
	}
	Component {
		id: compInwardsRadialSmooth
		StackedInwardsRadialVisualizerSmooth {
			outerRadius: 160
			innerRadius: 85
			values: [content.layerB0, content.layerB1, content.layerB2]
			colors: content.colorsB
			opacity: content.previewOpacity
		}
	}
	Component {
		id: compOutwardsRadialSmooth
		StackedOutwardsRadialVisualizerSmooth {
			outerRadius: 170
			innerRadius: 90
			values: [content.layerB0, content.layerB1, content.layerB2]
			colors: content.colorsB
			opacity: content.previewOpacity
		}
	}
	Component {
		id: compCenteredRadialSmooth
		StackedCenteredRadialVisualizerSmooth {
			outerRadius: 180
			innerRadius: 90
			values: [content.layerC0, content.layerC1]
			colors: content.colorsC
			opacity: content.previewOpacity
		}
	}

	property var visualizerDefs: [
		{ title: "StackedInwardsRadialVisualizerBars", category: "bars", slotSize: 340, component: compInwardsRadialBars },
		{ title: "StackedHVisualizerBars", category: "bars", slotSize: 280, component: compHBars },
		{ title: "StackedVVisualizerBars", category: "bars", slotSize: 280, component: compVBars },
		{ title: "StackedOutwardsRadialVisualizerBars", category: "bars", slotSize: 340, component: compOutwardsRadialBars },
		{ title: "StackedHVisualizerSmooth", category: "smooth", slotSize: 280, component: compHSmooth },
		{ title: "StackedVVisualizerSmooth", category: "smooth", slotSize: 280, component: compVSmooth },
		{ title: "StackedInwardsRadialVisualizerSmooth", category: "smooth", slotSize: 360, component: compInwardsRadialSmooth },
		{ title: "StackedOutwardsRadialVisualizerSmooth", category: "smooth", slotSize: 380, component: compOutwardsRadialSmooth },
		{ title: "StackedCenteredRadialVisualizerSmooth", category: "smooth", slotSize: 400, component: compCenteredRadialSmooth },
	]

	// --- per-tab grids -----------------------------------------------------
	// Each tab is its own Component: a Flickable grid of glass cards over a
	// category-filtered slice of `visualizerDefs`. The card delegate (with its
	// scroll-based `inView` lazy-load) is duplicated per tab rather than factored
	// into one shared Component, because it reads its own tab's Flickable by id —
	// ids declared inside one top-level Component aren't visible from another.
	Component {
		id: compBarsTab
		Flickable {
			id: flickBars
			clip: true
			contentWidth: gridBars.implicitWidth
			contentHeight: gridBars.implicitHeight
			boundsBehavior: Flickable.StopAtBounds

			GridLayout {
				id: gridBars
				columns: 3
				rowSpacing: 56
				columnSpacing: 56

				Repeater {
					model: content.visualizerDefs.filter(d => d.category === "bars")

					// One glass card per visualizer definition. `inView` gates lazy
					// instantiation; `pinned` (click-to-select) overrides it so a card
					// the user is looking at doesn't unload if they keep scrolling.
					Item {
						id: card
						required property var modelData
						required property int index

						implicitWidth: modelData.slotSize
						implicitHeight: modelData.slotSize + 40

						property bool pinned: false
						readonly property real preloadMargin: 300
						readonly property bool inView: (card.y + card.height > flickBars.contentY - card.preloadMargin)
							&& (card.y < flickBars.contentY + flickBars.height + card.preloadMargin)
						readonly property bool shouldLoad: card.inView || card.pinned

						Rectangle {
							anchors.fill: parent
							radius: content.cardRadius
							color: card.pinned ? "#1f3b82f6" : content.glassBg
							border.width: 1
							border.color: card.pinned ? content.accent : content.glassBorder

							// Faint top-left sheen to hint at a beveled glass edge, since
							// QML Rectangle borders are single-color (no per-side control).
							Rectangle {
								anchors.top: parent.top
								anchors.left: parent.left
								anchors.right: parent.right
								height: 1
								radius: parent.radius
								color: content.glassBorderLight
							}
						}

						MouseArea {
							anchors.fill: parent
							onClicked: card.pinned = !card.pinned
						}

						ColumnLayout {
							anchors.fill: parent
							anchors.margins: 12
							spacing: 8

							Text {
								text: card.modelData.title
								color: "white"
								font.pixelSize: 13
								Layout.alignment: Qt.AlignHCenter
								horizontalAlignment: Text.AlignHCenter
								Layout.fillWidth: true
								wrapMode: Text.WordWrap
							}

							Item {
								Layout.fillWidth: true
								Layout.fillHeight: true
								clip: true

								Loader {
									anchors.centerIn: parent
									active: card.shouldLoad
									sourceComponent: card.modelData.component
								}

								// Lightweight placeholder shown while the card is out of
								// view and not yet loaded — keeps the grid slot occupied
								// and makes the lazy-load boundary visible while testing.
								Rectangle {
									anchors.centerIn: parent
									visible: !card.shouldLoad
									width: 64
									height: 64
									radius: 32
									color: "transparent"
									border.width: 1
									border.color: content.glassBorderLight

									Text {
										anchors.centerIn: parent
										text: "…"
										color: "#666666"
										font.pixelSize: 20
									}
								}
							}
						}

						// Rounded-border outline drawn above everything else in the card
						// (including the visualizer content, which can render larger than
						// its slot) so the card's rounded corners always stay visible
						// instead of being covered by overflowing visualizer content.
						Rectangle {
							anchors.fill: parent
							radius: content.cardRadius
							color: "transparent"
							border.width: 1
							border.color: card.pinned ? content.accent : content.glassBorder
						}
					}
				}
			}
		}
	}
	Component {
		id: compSmoothTab
		Flickable {
			id: flickSmooth
			clip: true
			contentWidth: gridSmooth.implicitWidth
			contentHeight: gridSmooth.implicitHeight
			boundsBehavior: Flickable.StopAtBounds

			GridLayout {
				id: gridSmooth
				columns: 3
				rowSpacing: 56
				columnSpacing: 56

				Repeater {
					model: content.visualizerDefs.filter(d => d.category === "smooth")

					Item {
						id: card
						required property var modelData
						required property int index

						implicitWidth: modelData.slotSize
						implicitHeight: modelData.slotSize + 40

						property bool pinned: false
						readonly property real preloadMargin: 300
						readonly property bool inView: (card.y + card.height > flickSmooth.contentY - card.preloadMargin)
							&& (card.y < flickSmooth.contentY + flickSmooth.height + card.preloadMargin)
						readonly property bool shouldLoad: card.inView || card.pinned

						Rectangle {
							anchors.fill: parent
							radius: content.cardRadius
							color: card.pinned ? "#1f3b82f6" : content.glassBg
							border.width: 1
							border.color: card.pinned ? content.accent : content.glassBorder

							Rectangle {
								anchors.top: parent.top
								anchors.left: parent.left
								anchors.right: parent.right
								height: 1
								radius: parent.radius
								color: content.glassBorderLight
							}
						}

						MouseArea {
							anchors.fill: parent
							onClicked: card.pinned = !card.pinned
						}

						ColumnLayout {
							anchors.fill: parent
							anchors.margins: 12
							spacing: 8

							Text {
								text: card.modelData.title
								color: "white"
								font.pixelSize: 13
								Layout.alignment: Qt.AlignHCenter
								horizontalAlignment: Text.AlignHCenter
								Layout.fillWidth: true
								wrapMode: Text.WordWrap
							}

							Item {
								Layout.fillWidth: true
								Layout.fillHeight: true
								clip: true

								Loader {
									anchors.centerIn: parent
									active: card.shouldLoad
									sourceComponent: card.modelData.component
								}

								Rectangle {
									anchors.centerIn: parent
									visible: !card.shouldLoad
									width: 64
									height: 64
									radius: 32
									color: "transparent"
									border.width: 1
									border.color: content.glassBorderLight

									Text {
										anchors.centerIn: parent
										text: "…"
										color: "#666666"
										font.pixelSize: 20
									}
								}
							}
						}

						// Rounded-border outline drawn above everything else in the card
						// (including the visualizer content, which can render larger than
						// its slot) so the card's rounded corners always stay visible
						// instead of being covered by overflowing visualizer content.
						Rectangle {
							anchors.fill: parent
							radius: content.cardRadius
							color: "transparent"
							border.width: 1
							border.color: card.pinned ? content.accent : content.glassBorder
						}
					}
				}
			}
		}
	}

	// --- background --------------------------------------------------------
	// Light, low-chroma, very translucent fill — this sits behind everything else,
	// so it also lets the popup's own rounded/translucent glass background
	// (component/PopupWindow.qml) show through when this content is hosted as a
	// popup rather than the standalone window. Reuses style.bar.bg directly (rather
	// than a duplicated local color) so this matches the bar's own glass tone.
	Rectangle {
		anchors.fill: parent
		color: Config._.style.bar.bg
	}

	ColumnLayout {
		anchors.fill: parent
		anchors.margins: 20
		spacing: 12

		RowLayout {
			Layout.fillWidth: true

			// No explicit close button: as a popup this closes on click-outside via
			// HyprlandFocusGrab (component/PopupWindow.qml), like every other popup in
			// the shell; standalone runs close on Escape (Shortcut above) or window-close.
		}

		TabbedView {
			Layout.fillWidth: true
			Layout.fillHeight: true
			tabs: [
				{ label: "visualizers (bars)", component: compBarsTab },
				{ label: "visualizers (smooth)", component: compSmoothTab },
			]
		}
	}
}
