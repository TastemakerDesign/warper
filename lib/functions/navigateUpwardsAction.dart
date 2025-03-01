import "dart:io";

import "package:warper/functions/canNavigateUpwards.dart";
import "package:warper/stores/CurrentFolderStore.dart";
import "package:warper/stores/FileHighlightingStore.dart";
import "package:warper/stores/SongListStore.dart";

Future<void> navigateUpwardsAction() async {
  final currentFolderStore = useCurentFolderStore();
  final songListStore = useSongListStore();
  final fileHighlightingStore = useFileHighlightingStore();
  final currentPath = currentFolderStore.state.currentFolderPath;
  if (currentPath == null) {
    return;
  }
  if (!canNavigateUpwards(currentPath)) {
    return;
  }
  final parentDir = Directory(currentPath).parent;
  if (parentDir.path == currentPath) {
    return;
  }
  currentFolderStore.setFolder(parentDir.path);
  await songListStore.scanForFilesAndFolders(parentDir.path);
  await fileHighlightingStore.highlightEntryFromTeleport(
    Directory(currentPath),
    false,
  );
}
