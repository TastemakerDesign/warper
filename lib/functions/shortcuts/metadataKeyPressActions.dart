import "package:flutter/services.dart";
import "package:warper/functions/shortcuts/ActionType.dart";
import "package:warper/stores/MetadataDialogStore.dart";

final List<ActionType> metadataKeyPressActions = [
  (
    name: "Close Metadata Dialog",
    shortcuts: [
      (LogicalKeyboardKey.escape, false, false, false),
    ],
    action: () {
      final metadataDialogStore = useMetadataDialogStore();
      metadataDialogStore.hideDialog();
    },
  ),
];
