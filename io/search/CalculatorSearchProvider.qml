pragma Singleton

import QtQuick
import "root:/library/Calculator.mjs" as Calculator

Singleton {
  function suggestions(query) {
    const result = Calculator.calculate(query);
    if (result === undefined) {
      return [];
    }
    const suggestion = {
      icon: "calculator",
      title: String(result),
      subtitle: qsTr("Calculator result"),
      source: qsTr("Calculator"),
    };
    return [suggestion];
  }
}
