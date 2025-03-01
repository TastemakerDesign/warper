import "package:flutter/services.dart";
import "package:warper/functions/shortcuts/ActionType.dart";
import "package:warper/functions/shortcuts/ShortcutType.dart";
import "package:warper/functions/shortcuts/handleSearchQueryCharacterTyped.dart";
import "package:warper/functions/shortcuts/metadataKeyPressActions.dart";
import "package:warper/functions/shortcuts/normalKeyPressActions.dart";
import "package:warper/functions/shortcuts/searchKeyPressActions.dart";
import "package:warper/functions/shortcuts/shortcutKeyPressActions.dart";
import "package:warper/stores/MetadataDialogStore.dart";
import "package:warper/stores/SearchQueryStore.dart";
import "package:warper/stores/ShortcutsDialogStore.dart";

Future<void> handleKeyPress(KeyEvent event) async {
  if (event is KeyUpEvent) {
    return;
  }
  // After one press of the escape key, they keyboard event for escape will
  // trigger infinitely until the escape key is pressed again.
  // This is most likely a bug in Flutter.
  if (event.timeStamp.inMilliseconds == 0) {
    assert(event.logicalKey == LogicalKeyboardKey.escape);
    return;
  }
  final searchQueryStore = useSearchQueryStore();
  final shortcutsDialogStore = useShortcutsDialogStore();
  final metadataDialogStore = useMetadataDialogStore();
  final isSearchDialogVisible = searchQueryStore.state.isSearchDialogVisible;
  final isShortcutsDialogVisible =
      shortcutsDialogStore.state.isShortcutsDialogVisible;
  final isMetadataDialogVisible =
      metadataDialogStore.state.isMetadataDialogVisible;
  final ShortcutType userInput = (
    event.logicalKey,
    HardwareKeyboard.instance.isMetaPressed,
    HardwareKeyboard.instance.isShiftPressed,
    HardwareKeyboard.instance.isAltPressed,
  );
  List<ActionType> actions;
  if (isShortcutsDialogVisible) {
    actions = shortcutKeyPressActions;
  } else if (isSearchDialogVisible) {
    actions = searchKeyPressActions;
  } else if (isMetadataDialogVisible) {
    actions = metadataKeyPressActions;
  } else {
    actions = normalKeyPressActions;
  }
  for (final action in actions) {
    for (final shortcut in action.shortcuts) {
      if (userInput == shortcut) {
        await action.action();
        return;
      }
    }
  }
  if (isShortcutsDialogVisible || isMetadataDialogVisible) {
    // Do nothing.
  } else if (isSearchDialogVisible) {
    handleSearchQueryCharacterTyped(event, false);
  } else {
    handleSearchQueryCharacterTyped(event, true);
  }
}
