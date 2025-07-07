pragma Singleton

import Quickshell.Services.SystemTray
import "root:/library/Strings.mjs" as Strings

Singleton {
  function search(query: string): list<var> {
    const regexes = Strings.regExpEscape(query).split(" ").map(term => new RegExp(term, "i"));
    const isMatch = s => regexes.every(regex => regex.test(s));
    return SystemTray.items
      .filter(item => isMatch(item.title) || isMatch(item.id) || isMatch(item.tooltipTitle) || isMatch(item.tooltipDescription))
      .map(item => ({
        icon: item.icon,
        title: item.title,
        subtitle: item.tooltipDescription,
        source: qsTr("Tray"),
        execute: () => { /* TODO: */ },
      }));
  }
}
