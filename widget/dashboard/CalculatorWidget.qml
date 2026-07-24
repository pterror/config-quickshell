import QtQuick
import QtQuick.Layouts
import qs.component
import qs

// Expression-based calculator: buttons (and direct typing) build a string, "=" hands it
// to JS to evaluate. Scientific mode adds trig/log/factorial/constants; a separate
// toggle switches the result display to scientific notation. Keeps a short history of
// recent calculations, click one to recall its expression.
DashboardWidget {
	id: root
	resizable: true
	implicitWidth: 260
	implicitHeight: 332

	property string expression: ""
	property string resultText: ""
	property bool hasError: false
	property bool scientific: false
	property bool sciNotation: false
	property list<var> history: [] // [{ expr: string, result: real }]
	readonly property string displayText: {
		if (root.hasError) return "Error"
		if (root.resultText.length > 0) return root.resultText
		if (root.expression.length > 0) return root.expression
		return "0"
	}
	readonly property string expressionPreview: root.hasError ? root.expression : (root.resultText.length > 0 ? root.expression : "")

	readonly property string livePreview: {
		if (root.expression.trim().length === 0) return ""
		try {
			const value = eval(root.preprocessExpr(root.expression))
			return (typeof value === "number" && isFinite(value)) ? root.formatResult(value) : ""
		} catch (e) {
			return ""
		}
	}

	function factorialOf(n: real): real {
		if (!Number.isInteger(n) || n < 0 || n > 170) return NaN
		let result = 1
		for (let i = 2; i <= n; i++) result *= i
		return result
	}

	// Rewrites calculator-friendly tokens (inserted by the scientific buttons, or typed
	// directly) into plain JS before eval(): named functions -> Math.*, "^" -> "**",
	// and any N! -> its precomputed numeric value (innermost/leftmost first).
	function preprocessExpr(expr: string): string {
		let out = expr
			.replace(/sin\(/g, "Math.sin(")
			.replace(/cos\(/g, "Math.cos(")
			.replace(/tan\(/g, "Math.tan(")
			.replace(/log\(/g, "Math.log10(")
			.replace(/ln\(/g, "Math.log(")
			.replace(/√\(/g, "Math.sqrt(")
			.replace(/π/g, "Math.PI")
			.replace(/𝑒/g, "Math.E")
			.replace(/\^/g, "**")
		while (out.includes("!")) {
			const next = out.replace(/(\d+(?:\.\d+)?)!/, (_, n) => String(root.factorialOf(Number(n))))
			if (next === out) break // stray "!" with nothing valid before it
			out = next
		}
		return out
	}

	function formatResult(value: real): string {
		if (root.sciNotation) return value.toExponential(6)
		return String(Number(value.toPrecision(12)))
	}

	function append(token: string) {
		if (root.hasError) {
			root.expression = ""
			root.resultText = ""
			root.hasError = false
		}
		if (root.resultText.length > 0 && /^[0-9.]$/.test(token)) {
			root.expression = ""
			root.resultText = ""
		}
		root.expression += token
	}

	function backspace() {
		root.expression = root.expression.slice(0, -1)
	}

	function clear() {
		root.expression = ""
		root.resultText = ""
		root.hasError = false
	}

	function evaluate() {
		if (root.expression.trim().length === 0) return
		try {
			const value = eval(root.preprocessExpr(root.expression))
			if (typeof value !== "number" || !isFinite(value)) throw new Error("non-numeric result")
			root.history = [{ expr: root.expression, result: value }].concat(root.history).slice(0, 20)
			root.resultText = root.formatResult(value)
			root.hasError = false
		} catch (e) {
			root.hasError = true
			root.resultText = "Error"
		}
	}

	function recall(entry: var) {
		root.expression = entry.expr
		root.resultText = root.formatResult(entry.result)
		root.hasError = false
	}

	function buttonText(entry: var): string {
		switch (entry.label) {
		case "/": return "÷"
		case "*": return "×"
		case "-": return "−"
		default: return entry.label
		}
	}

	ColumnLayout {
		anchors.fill: parent
		spacing: Config._.style.widget.margins

		Rectangle {
			Layout.fillWidth: true
			implicitHeight: 78
			radius: Config._.style.widget.radius
			color: Config._.style.widget.bg
			border.color: Config._.style.widget.outline
			border.width: Config._.style.widget.border

			ColumnLayout {
				anchors.fill: parent
				anchors.margins: 8
				spacing: 2

				Text {
					Layout.fillWidth: true
					horizontalAlignment: Text.AlignRight
					color: Config._.style.widget.outline
					font.family: Config._.font.family
					font.pointSize: Config._.style.widget.fontSize - 1
					elide: Text.ElideLeft
					text: root.expressionPreview.length > 0
						? root.expressionPreview
						: (!root.hasError ? root.livePreview : "")
				}

				Text {
					Layout.fillWidth: true
					horizontalAlignment: Text.AlignRight
					color: root.hasError ? "#ff8080" : Config._.style.widget.fg
					font.family: Config._.font.family
					font.pointSize: Config._.style.widget.fontSize + 8
					font.bold: true
					elide: Text.ElideLeft
					text: root.displayText
				}
			}
		}

		RowLayout {
			Layout.fillWidth: true

			CalculatorToggle {
				text: root.scientific ? "basic" : "scientific"
				active: root.scientific
				onClicked: root.scientific = !root.scientific
			}
			CalculatorToggle {
				text: "exp"
				active: root.sciNotation
				onClicked: root.sciNotation = !root.sciNotation
			}
			Item { Layout.fillWidth: true }
		}

		GridLayout {
			Layout.fillWidth: true
			visible: root.scientific
			columns: 5
			columnSpacing: 3
			rowSpacing: 3

			Repeater {
				model: [
					{ label: "sin", insert: "sin(" },
					{ label: "cos", insert: "cos(" },
					{ label: "tan", insert: "tan(" },
					{ label: "log", insert: "log(" },
					{ label: "ln", insert: "ln(" },
					{ label: "√", insert: "√(" },
					{ label: "^", insert: "^" },
					{ label: "x!", insert: "!" },
					{ label: "π", insert: "π" },
					{ label: "e", insert: "𝑒" },
				]
				CalculatorButton {
					required property var modelData
					Layout.fillWidth: true
					Layout.preferredHeight: 28
					text: modelData.label
					operatorButton: true
					onClicked: root.append(modelData.insert)
				}
			}
		}

		GridLayout {
			Layout.fillWidth: true
			Layout.fillHeight: true
			columns: 4
			columnSpacing: 3
			rowSpacing: 3

			Repeater {
				model: [
					{ label: "C", action: "clear" },
					{ label: "(", action: "insert", value: "(" },
					{ label: ")", action: "insert", value: ")" },
					{ label: "DEL", action: "backspace" },
					{ label: "7", action: "insert", value: "7" },
					{ label: "8", action: "insert", value: "8" },
					{ label: "9", action: "insert", value: "9" },
					{ label: "/", action: "insert", value: "/" },
					{ label: "4", action: "insert", value: "4" },
					{ label: "5", action: "insert", value: "5" },
					{ label: "6", action: "insert", value: "6" },
					{ label: "*", action: "insert", value: "*" },
					{ label: "1", action: "insert", value: "1" },
					{ label: "2", action: "insert", value: "2" },
					{ label: "3", action: "insert", value: "3" },
					{ label: "-", action: "insert", value: "-" },
					{ label: "0", action: "insert", value: "0" },
					{ label: ".", action: "insert", value: "." },
					{ label: "=", action: "evaluate" },
					{ label: "+", action: "insert", value: "+" },
				]
				CalculatorButton {
					required property var modelData
					Layout.fillWidth: true
					Layout.fillHeight: true
					text: root.buttonText(modelData)
					emphasize: modelData.action === "evaluate"
					operatorButton: ["/", "*", "-", "+"].includes(modelData.label)
					onClicked: {
						switch (modelData.action) {
						case "clear": root.clear(); break
						case "backspace": root.backspace(); break
						case "evaluate": root.evaluate(); break
						default: root.append(modelData.value)
						}
					}
				}
			}
		}

		ListView {
			Layout.fillWidth: true
			Layout.preferredHeight: root.history.length > 0 ? 44 : 0
			clip: true
			visible: root.history.length > 0
			model: root.history

			delegate: Rectangle {
				id: historyRow
				required property var modelData
				width: ListView.view.width
				height: 22
				color: historyArea.containsMouse ? Config._.style.widget.hoverBg : "transparent"

				RowLayout {
					anchors.fill: parent
					anchors.margins: 2

					Text {
						Layout.fillWidth: true
						text: historyRow.modelData.expr
						color: Config._.style.widget.outline
						font.family: Config._.font.family
						font.pointSize: Config._.style.widget.fontSize - 2
						elide: Text.ElideLeft
					}
					Text {
						text: "= " + root.formatResult(historyRow.modelData.result)
						color: Config._.style.widget.fg
						font.family: Config._.font.family
						font.pointSize: Config._.style.widget.fontSize - 2
					}
				}

				MouseArea {
					id: historyArea
					anchors.fill: parent
					hoverEnabled: true
					cursorShape: Qt.PointingHandCursor
					onClicked: root.recall(historyRow.modelData)
				}
			}
		}
	}
}
