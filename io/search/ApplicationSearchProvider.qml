pragma Singleton

import Quickshell
import "root:/library/Strings.mjs" as Strings
import "root:/library/Calculator.mjs" as Calculator

Singleton {
  function search(query: string): list<var> {
    const regexes = Strings.regExpEscape(query).split(" ").map(term => new RegExp(term, "i"));
    const isMatch = s => regexes.every(regex => regex.test(s));
    return DesktopEntries.applications
      .filter(app => isMatch(app.name) || isMatch(app.genericName) || isMatch(app.comment))
      .map(app => ({
        icon: app.icon,
        title: app.name,
        subtitle: app.comment,
        source: qsTr("Application"),
        execute: () => { app.execute(); },
      }));
  }
}
