import QtQuick
import QtQuick.Layouts
import qs.component
import qs.widget
import qs
import "./showcase"

// Plain Item so it can be hosted by either the standalone window (VisualizerShowcase.qml)
// or a popup from PterrorStatBar.qml.
//
	// Data is procedurally generated sine waves, not real audio/CPU, so the stacking and
	// animation can be eyeballed in isolation; datasets are reused across widgets that
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

	// Dataset A: drives bar visualizers. Three layers, amplitudes chosen so the stack
	// never exceeds ~1.0.
	property list<var> layerA0: content.wave(content.barCount, 3, 0.0, 0.28, 0.05)
	property list<var> layerA1: content.wave(content.barCount, 5, 1.3, 0.22, 0.04)
	property list<var> layerA2: content.wave(content.barCount, 2, 2.6, 0.18, 0.03)
	property var colorsA: ["#ff6b6b", "#4ecdc4", "#ffe66d"]

	// Dataset B: drives smooth visualizers. Same shape as A but a different point count
	// for a smoother curve.
	property list<var> layerB0: content.wave(content.pointCount, 2, 0.0, 0.30, 0.05)
	property list<var> layerB1: content.wave(content.pointCount, 4, 1.7, 0.22, 0.04)
	property list<var> layerB2: content.wave(content.pointCount, 6, 3.1, 0.16, 0.03)
	property var colorsB: ["#ff6b6b", "#4ecdc4", "#ffe66d"]

	property list<var> layerC0: content.wave(content.pointCount, 3, 0.4, 0.30, 0.04)
	property list<var> layerC1: content.wave(content.pointCount, 5, 2.2, 0.22, 0.03)
	property var colorsC: ["#ff6b6b", "#4ecdc4"]

	// Fake `input` for the VisualizerBase-derived stacked bar widgets — they only read
	// `input.count` (the actual per-bar values come from the `values` prop), so a plain
	// object with a matching `count` avoids spawning a real Cava process.
	property QtObject fakeInput: QtObject { property int count: content.barCount }
	property QtObject fakeBarsInputA: QtObject {
		property int count: content.barCount
		property var values: content.layerA0
	}
	property QtObject fakeBarsInputB: QtObject {
		property int count: content.barCount
		property var values: content.layerA1
	}
	property QtObject fakeBarsInputC: QtObject {
		property int count: content.barCount
		property var values: content.layerA2
	}
	property QtObject fakeSmoothInputA: QtObject {
		property int count: content.pointCount
		property var values: content.layerB0
	}
	property QtObject fakeSmoothInputB: QtObject {
		property int count: content.pointCount
		property var values: content.layerB1
	}
	property QtObject fakeSmoothInputC: QtObject {
		property int count: content.pointCount
		property var values: content.layerC0
	}

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

	Component {
		id: compBasicInwardsRadialBars
		InwardsRadialVisualizerBars {
			input: content.fakeBarsInputA
			outerRadius: 118
			innerRadius: 76
			fillColor: "#ff6b6b"
			opacity: 0.68
		}
	}
	Component {
		id: compBasicHBars
		HVisualizerBars {
			input: content.fakeBarsInputB
			width: 280
			height: 160
			fillColor: "#4ecdc4"
			modulateOpacity: true
			minOpacity: 0.3
			maxOpacity: 0.7
		}
	}
	Component {
		id: compBasicVBars
		VVisualizerBars {
			input: content.fakeBarsInputC
			width: 160
			height: 280
			fillColor: "#ffe66d"
			modulateOpacity: true
			minOpacity: 0.3
			maxOpacity: 0.7
		}
	}
	Component {
		id: compBasicOutwardsRadialBars
		OutwardsRadialVisualizerBars {
			input: content.fakeBarsInputB
			outerRadius: 118
			innerRadius: 76
			fillColor: "#4ecdc4"
			opacity: 0.68
			modulateOpacity: true
			minOpacity: 0.3
			maxOpacity: 0.7
		}
	}

	Component {
		id: compInwardsRadialBars
		StackedInwardsRadialVisualizerBars {
			input: content.fakeInput
			outerRadius: 150
			innerRadius: 80
			values: [content.layerA0, content.layerA1, content.layerA2]
			colors: content.colorsA
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
			modulateOpacity: true
			minOpacity: 0.3
			maxOpacity: 0.7
		}
	}
	Component {
		id: compBasicHSmooth
		HVisualizerSmooth {
			width: 280
			height: 160
			fillColor: "#ff6b6b"
			opacity: 0.72
			input: content.fakeSmoothInputA
		}
	}
	Component {
		id: compBasicVSmooth
		VVisualizerSmooth {
			width: 160
			height: 280
			fillColor: "#4ecdc4"
			opacity: 0.72
			input: content.fakeSmoothInputB
		}
	}
	Component {
		id: compBasicInwardsRadialSmooth
		InwardsRadialVisualizerSmooth {
			outerRadius: 102
			innerRadius: 68
			fillColor: "#ffe66d"
			opacity: 0.66
			input: content.fakeSmoothInputA
		}
	}
	Component {
		id: compBasicOutwardsRadialSmooth
		OutwardsRadialVisualizerSmooth {
			outerRadius: 104
			innerRadius: 68
			fillColor: "#4ecdc4"
			opacity: 0.66
			input: content.fakeSmoothInputB
		}
	}
	Component {
		id: compBasicCenteredRadialSmooth
		CenteredRadialVisualizerSmooth {
			outerRadius: 110
			innerRadius: 68
			fillColor: "#ff6b6b"
			opacity: 0.66
			input: content.fakeSmoothInputC
		}
	}
	Component {
		id: compHSmooth
		StackedHVisualizerSmooth {
			width: 280
			height: 160
			values: [content.layerB0, content.layerB1, content.layerB2]
			colors: content.colorsB
			opacity: 0.72
		}
	}
	Component {
		id: compVSmooth
		StackedVVisualizerSmooth {
			width: 160
			height: 280
			values: [content.layerB0, content.layerB1, content.layerB2]
			colors: content.colorsB
			opacity: 0.72
		}
	}
	Component {
		id: compInwardsRadialSmooth
		StackedInwardsRadialVisualizerSmooth {
			outerRadius: 104
			innerRadius: 68
			values: [content.layerB0, content.layerB1, content.layerB2]
			colors: content.colorsB
			opacity: 0.7
		}
	}
	Component {
		id: compOutwardsRadialSmooth
		StackedOutwardsRadialVisualizerSmooth {
			outerRadius: 106
			innerRadius: 68
			values: [content.layerB0, content.layerB1, content.layerB2]
			colors: content.colorsB
			opacity: 0.7
		}
	}
	Component {
		id: compCenteredRadialSmooth
		StackedCenteredRadialVisualizerSmooth {
			outerRadius: 114
			innerRadius: 68
			values: [content.layerC0, content.layerC1]
			colors: content.colorsC
			opacity: 0.7
		}
	}

	property var visualizerDefs: [
		{ title: "InwardsRadialVisualizerBars", category: "bars-basic", slotSize: 340, component: compBasicInwardsRadialBars },
		{ title: "HVisualizerBars", category: "bars-basic", slotSize: 280, component: compBasicHBars },
		{ title: "VVisualizerBars", category: "bars-basic", slotSize: 280, component: compBasicVBars },
		{ title: "OutwardsRadialVisualizerBars", category: "bars-basic", slotSize: 340, component: compBasicOutwardsRadialBars },
		{ title: "StackedInwardsRadialVisualizerBars", category: "bars-stacked", slotSize: 340, component: compInwardsRadialBars },
		{ title: "StackedHVisualizerBars", category: "bars-stacked", slotSize: 280, component: compHBars },
		{ title: "StackedVVisualizerBars", category: "bars-stacked", slotSize: 280, component: compVBars },
		{ title: "StackedOutwardsRadialVisualizerBars", category: "bars-stacked", slotSize: 340, component: compOutwardsRadialBars },
		{ title: "HVisualizerSmooth", category: "smooth-basic", slotSize: 280, component: compBasicHSmooth },
		{ title: "VVisualizerSmooth", category: "smooth-basic", slotSize: 280, component: compBasicVSmooth },
		{ title: "InwardsRadialVisualizerSmooth", category: "smooth-basic", slotSize: 300, component: compBasicInwardsRadialSmooth },
		{ title: "OutwardsRadialVisualizerSmooth", category: "smooth-basic", slotSize: 300, component: compBasicOutwardsRadialSmooth },
		{ title: "CenteredRadialVisualizerSmooth", category: "smooth-basic", slotSize: 320, component: compBasicCenteredRadialSmooth },
		{ title: "StackedHVisualizerSmooth", category: "smooth-stacked", slotSize: 280, component: compHSmooth },
		{ title: "StackedVVisualizerSmooth", category: "smooth-stacked", slotSize: 280, component: compVSmooth },
		{ title: "StackedInwardsRadialVisualizerSmooth", category: "smooth-stacked", slotSize: 300, component: compInwardsRadialSmooth },
		{ title: "StackedOutwardsRadialVisualizerSmooth", category: "smooth-stacked", slotSize: 300, component: compOutwardsRadialSmooth },
		{ title: "StackedCenteredRadialVisualizerSmooth", category: "smooth-stacked", slotSize: 320, component: compCenteredRadialSmooth },
	]

	Component {
		id: compBarsBasicTab
		VisualizerGridTab {
			category: "bars-basic"
			visualizerDefs: content.visualizerDefs
			glassBg: content.glassBg
			glassBorder: content.glassBorder
			glassBorderLight: content.glassBorderLight
			accent: content.accent
			cardRadius: content.cardRadius
		}
	}
	Component {
		id: compBarsStackedTab
		VisualizerGridTab {
			category: "bars-stacked"
			visualizerDefs: content.visualizerDefs
				glassBg: content.glassBg
				glassBorder: content.glassBorder
				glassBorderLight: content.glassBorderLight
				accent: content.accent
				cardRadius: content.cardRadius
			}
	}
	Component {
		id: compSmoothBasicTab
		VisualizerGridTab {
			category: "smooth-basic"
			visualizerDefs: content.visualizerDefs
				glassBg: content.glassBg
				glassBorder: content.glassBorder
				glassBorderLight: content.glassBorderLight
				accent: content.accent
				cardRadius: content.cardRadius
			}
	}
	Component {
		id: compSmoothStackedTab
		VisualizerGridTab {
			category: "smooth-stacked"
			visualizerDefs: content.visualizerDefs
				glassBg: content.glassBg
				glassBorder: content.glassBorder
			glassBorderLight: content.glassBorderLight
			accent: content.accent
			cardRadius: content.cardRadius
		}
	}
	Component {
		id: compVisualizersTab
		TabbedView {
			anchors.fill: parent
			tabs: [
				{ label: "bars", component: compBarsBasicTab },
				{ label: "bars stacked", component: compBarsStackedTab },
				{ label: "smooth", component: compSmoothBasicTab },
				{ label: "smooth stacked", component: compSmoothStackedTab },
			]
		}
	}
	Component {
		id: compGeodesicSpherePreviewTab
		GeodesicSpherePreviewTab {}
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
				{ label: "visualizers", component: compVisualizersTab },
				{ label: "geodesic sphere preview", component: compGeodesicSpherePreviewTab },
			]
		}
	}
}
