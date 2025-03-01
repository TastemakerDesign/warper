import "dart:io";

import "package:path/path.dart" as p;
import "package:warper/stores/SongListStore.dart";

String getSongTitle(FileSystemEntity fileSystemEntity) {
  final songListStore = useSongListStore();
  final filePath = fileSystemEntity.path;
  final tag = songListStore.getMetadataForSong(fileSystemEntity.path);
  final trackName = tag?.trackName;
  return (trackName != null && trackName.isNotEmpty)
      ? trackName
      : p.basenameWithoutExtension(filePath);
}
