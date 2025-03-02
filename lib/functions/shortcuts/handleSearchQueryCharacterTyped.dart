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
    "F13",
    "F14",
    "F15",
    "F16",
    "F17",
    "F18",
    "F19",
    "Backspace",
    "Delete",
    "Page Up",
    "Page Down",
    "Home",
    "End",
    "Numpad Enter",
    "Num Lock",
  ];
  if (blackList.contains(keyLabel)) {
    return;
  }
  String transformedKeyLabel;
  switch (keyLabel) {
    case "Numpad 0":
      transformedKeyLabel = "0";
    case "Numpad 1":
      transformedKeyLabel = "1";
    case "Numpad 2":
      transformedKeyLabel = "2";
    case "Numpad 3":
      transformedKeyLabel = "3";
    case "Numpad 4":
      transformedKeyLabel = "4";
    case "Numpad 5":
      transformedKeyLabel = "5";
    case "Numpad 6":
      transformedKeyLabel = "6";
    case "Numpad 7":
      transformedKeyLabel = "7";
    case "Numpad 8":
      transformedKeyLabel = "8";
    case "Numpad 9":
      transformedKeyLabel = "9";
    case "Numpad Decimal":
      transformedKeyLabel = ".";
    case "Numpad Equal":
      transformedKeyLabel = "=";
    case "Numpad Divide":
      transformedKeyLabel = "/";
    case "Numpad Multiply":
      transformedKeyLabel = "*";
    case "Numpad Subtract":
      transformedKeyLabel = "-";
    case "Numpad Add":
      transformedKeyLabel = "+";
    default:
      transformedKeyLabel = keyLabel;
  }
  searchQueryStore.addCharacterToSearchQuery(transformedKeyLabel);
  searchQueryStore.showSearchDialog();
}
