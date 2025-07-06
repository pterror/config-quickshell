pragma Singleton

import "root:/library/Calculator.mjs" as Calculator

Singleton {
  function search(query: string): list<var> {
    const result = Calculator.calculate(query);
    if (result === undefined) {
      return [];
    }
    const suggestion = {
      icon: "calculator",
      title: String(result),
      subtitle: qsTr("Calculator result"),
      source: qsTr("Calculator"),
      execute: () => {},
    };
    return [suggestion];
  }
}
