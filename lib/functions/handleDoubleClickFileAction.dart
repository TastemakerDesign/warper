import "dart:io";

import "package:warper/stores/CurrentlyPlayingStore.dart";

Future<void> handleDoubleClickFileAction(
  FileSystemEntity fileSystemEntity,
) async {
  final currentlyPlayingStore = useCurrentlyPlayingStore();
  await currentlyPlayingStore.stopSong();
  await currentlyPlayingStore.playSong(fileSystemEntity);
}
