import "package:flutter/services.dart";
import "package:warper/functions/shortcuts/ActionType.dart";
import "package:warper/stores/ShortcutsDialogStore.dart";

final List<ActionType> shortcutKeyPressActions = [
  (
    name: "Close Shortcuts Dialog",
    shortcuts: [
      (LogicalKeyboardKey.escape, false, false, false),
    ],
    action: () {
      final shortcutsDialogStore = useShortcutsDialogStore();
      shortcutsDialogStore.hideDialog();
    },
  ),
];
