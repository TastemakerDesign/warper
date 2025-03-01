import "dart:io";

import "package:super_context_menu/super_context_menu.dart";
import "package:warper/stores/MetadataDialogStore.dart";

Menu buildSongListMenu(FileSystemEntity fileSystemEntity) {
  return Menu(
    children: [
      MenuAction(
        title: "Show in Finder",
        callback: () async => await _handleShowInFinder(fileSystemEntity),
      ),
      MenuAction(
        title: "Show Song Metadata",
        callback: () async => await _handleShowSongMetadata(fileSystemEntity),
      ),
    ],
  );
}

Future<void> _handleShowInFinder(FileSystemEntity fileSystemEntity) async {
  await Process.run(
    "open",
    ["-R", fileSystemEntity.path],
  );
}

Future<void> _handleShowSongMetadata(FileSystemEntity fileSystemEntity) async {
  final metadataDialogStore = useMetadataDialogStore();
  metadataDialogStore.showDialog(fileSystemEntity.path);
}
