import qs.component

ColumnLayout {
  required property QsMenuHandle menu

  QsOpener {
    id: opener
  }

  Repeater {
    model: 

    HoverItem {
      onClicked: {
        if (!mediaControlsLoader.active) mediaControlsLoader.loading = true;
        else mediaControlsLoader.active = false;
      }

      Text2 {
        //
      }
    }
  }
}