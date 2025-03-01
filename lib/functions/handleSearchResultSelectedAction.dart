import "dart:io";

import "package:flutter_media_metadata/flutter_media_metadata.dart";
import "package:warper/functions/handleDoubleClickFileAction.dart";
import "package:warper/stores/CurrentlyPlayingStore.dart";
import "package:warper/stores/SearchQueryStore.dart";

Future<void> handleSearchResultSelectedAction(Metadata? song) async {
  final searchQueryStore = useSearchQueryStore();
  final currentlyPlayingStore = useCurrentlyPlayingStore();
  final filePath = song?.filePath;
  if (filePath == null) {
    return;
  }
  await handleDoubleClickFileAction(File(filePath));
  await currentlyPlayingStore.navigateToCurrentlyPlayingFolder();
  searchQueryStore.hideSearchDialog();
}
