import "dart:io";

import "package:warper/functions/handleDoubleClickFileAction.dart";
import "package:warper/functions/handleDoubleClickFolderAction.dart";
import "package:warper/stores/FileHighlightingStore.dart";

Future<void> handleFileEntityAction() async {
  final fileHighlightingStore = useFileHighlightingStore();
  final currentlySelected = fileHighlightingStore.state.currentlySelected;
  if (currentlySelected == null) {
    return;
  }
  if (currentlySelected is Directory) {
    final fileHighlightingStore = useFileHighlightingStore();
    await handleDoubleClickFolderAction(currentlySelected);
    await fileHighlightingStore.highlightEntryFromTeleport(
      currentlySelected,
      true,
    );
  } else {
    await handleDoubleClickFileAction(currentlySelected);
  }
}
