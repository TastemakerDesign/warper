import "dart:io";

import "package:flutter_media_metadata/flutter_media_metadata.dart";
import "package:warper/functions/getAlbumName.dart";
import "package:warper/functions/getSongTitle.dart";

List<Metadata?> filterSongsBySearchQuery(
  String searchQuery,
  Map<String, Metadata?>? songMetadata,
) {
  if (songMetadata == null) {
    return [];
  }
  final metadatas = songMetadata.values.toList();
  final filteredSongs =
      metadatas.where((metadata) => _filterFn(metadata, searchQuery)).toList();
  filteredSongs.sort((a, b) => _sortFn(a, b));
  return filteredSongs;
}

bool _filterFn(
  Metadata? metadata,
  String searchQuery,
) {
  final filePath = metadata?.filePath;
  final songTitle = filePath != null ? getSongTitle(File(filePath)) : "";
  final isMatchSongTitle =
      songTitle.toLowerCase().contains(searchQuery.toLowerCase());
  final albumName = filePath != null ? getAlbumName(File(filePath)) : "";
  final isMatchFilePath =
      albumName.toLowerCase().contains(searchQuery.toLowerCase());
  return isMatchSongTitle || isMatchFilePath;
}

int _sortFn(Metadata? a, Metadata? b) {
  final aFilePath = a?.filePath;
  final bFilePath = b?.filePath;
  final albumA = aFilePath != null ? getAlbumName(File(aFilePath)) : "";
  final albumB = bFilePath != null ? getAlbumName(File(bFilePath)) : "";
  final trackA = a?.trackNumber ?? 0;
  final trackB = b?.trackNumber ?? 0;
  final albumComparison = albumA.toLowerCase().compareTo(albumB.toLowerCase());
  final trackComparison = trackA.compareTo(trackB);
  if (albumComparison != 0) {
    return albumComparison;
  }
  return trackComparison;
}
