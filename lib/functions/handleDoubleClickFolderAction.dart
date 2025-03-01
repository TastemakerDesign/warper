import "dart:io";

import "package:warper/stores/CurrentFolderStore.dart";
import "package:warper/stores/SongListStore.dart";

Future<void> handleDoubleClickFolderAction(
  FileSystemEntity folderFileSystemEntity,
) async {
  final currentFolderStore = useCurentFolderStore();
  final songListStore = useSongListStore();
  currentFolderStore.setFolder(folderFileSystemEntity.path);
  await songListStore.scanForFilesAndFolders(folderFileSystemEntity.path);
}
