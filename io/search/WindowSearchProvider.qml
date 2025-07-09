pragma Singleton

import Quickshell.Services.SystemTray
import "root:/library/Strings.mjs" as Strings
import "root:/library/Applications.mjs" as Applications

Singleton {
  function search(query: string): list<var> {
    const regexes = Strings.regExpEscape(query).split(" ").map(term => new RegExp(term, "i"));
    const isMatch = s => regexes.every(regex => regex.test(s));
    return Config.services.compositor.clientsData
      .filter(item => isMatch(item.title) || isMatch(item.class))
      .map(item => ({
        icon: Applications.guessIcon(item.class),
        title: item.title,
        subtitle: item.initialTitle,
        source: qsTr("Tray"),
        execute: () => {
          Config.services.compositor.focusWindow("address:" + item.address)
        },
      }));
  }
}
