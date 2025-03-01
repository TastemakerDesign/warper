import "package:flutter/material.dart";
import "package:warper/stores/SearchQueryStore.dart";

void handleSearchQueryCharacterTyped(KeyEvent event, bool isFirstCharacter) {
  final searchQueryStore = useSearchQueryStore();
  final keyLabel = event.logicalKey.keyLabel;
  final blackList = [
    "Meta Left",
    "Meta Right",
    "Alt Left",
    "Alt Right",
    "Control Left",
    "Control Right",
    "Shift Left",
    "Shift Right",
    "Tab",
    "Escape",
    "Arrow Down",
    "Arrow Left",
    "Arrow Right",
    "Arrow Up",
    "Enter",
    "Caps Lock",
    "F1",
    "F2",
    "F3",
    "F4",
    "F5",
    "F6",
    "F7",
    "F8",
    "F9",
    "F10",
    "F11",
    "F12",
    "Backspace",
    "Page Up",
    "Page Down",
    "Home",
    "End",
  ];
  if (blackList.contains(keyLabel)) {
    return;
  }
  searchQueryStore.addCharacterToSearchQuery(keyLabel);
  searchQueryStore.showSearchDialog();
}
