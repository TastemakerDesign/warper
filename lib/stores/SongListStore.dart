import "dart:async";
import "dart:io";

import "package:flutter/material.dart";
import "package:flutter_media_metadata/flutter_media_metadata.dart";
import "package:flutter_zustand/flutter_zustand.dart";
import "package:warper/functions/isAudioFile.dart";
import "package:warper/functions/songSortFn.dart";

class SongListStore extends Store<
    ({
      List<FileSystemEntity>? songList,
      Map<String, Metadata?>? songMetadata,
      Map<String, GlobalKey>? globalKeys,
    })> {
  SongListStore()
      : super(
          (
            songList: null,
            songMetadata: null,
            globalKeys: null,
          ),
        );

  Future<Metadata?> _getMetadata(File file) async {
    final songMetadata = state.songMetadata?[file.path];
    if (songMetadata != null) {
      return songMetadata;
    }
    try {
      final metadata = await MetadataRetriever.fromFile(file);
      return metadata;
    } catch (_) {
      return null;
    }
  }

  GlobalKey getGlobalKeyForSong(String filePath) {
    if (state.globalKeys == null) {
      set(
        (
          globalKeys: {},
          songList: state.songList,
          songMetadata: state.songMetadata,
        ),
      );
    }
    if (state.globalKeys![filePath] == null) {
      state.globalKeys![filePath] = GlobalKey();
    }
    return state.globalKeys![filePath]!;
  }

  Future<void> scanForFilesAndFolders(String directoryPath) async {
    final dir = Directory(directoryPath);
    if (!await dir.exists()) {
      return;
    }

    // Get surface level files first for immediate display
    final (entries, surfaceMetadata) =
        await _scanForFilesAndFoldersInternal(directoryPath, false);

    // Update state with initial results
    set(
      (
        songList: entries,
        songMetadata: {...?state.songMetadata, ...surfaceMetadata},
        globalKeys: state.globalKeys,
      ),
    );

    // Start recursive metadata scan in the background
    unawaited(() async {
      try {
        final (_, recursiveMetadata) =
            await _scanForFilesAndFoldersInternal(directoryPath, true);
        set(
          (
            songList: entries,
            songMetadata: {
              ...?state.songMetadata,
              ...recursiveMetadata,
            },
            globalKeys: state.globalKeys,
          ),
        );
      } catch (_) {
        return;
      }
    }());
  }

  Future<List<FileSystemEntity>> getSongList(String directoryPath) async {
    final (songList, _) = await _scanForFilesAndFoldersInternal(
      directoryPath,
      false,
    );
    return songList;
  }

  Metadata? getMetadataForSong(String songPath) {
    return state.songMetadata?[songPath];
  }

  Future<(List<FileSystemEntity>, Map<String, Metadata?>)>
      _scanForFilesAndFoldersInternal(
    String directoryPath,
    bool isRecursive,
  ) async {
    final dir = Directory(directoryPath);
    List<FileSystemEntity> entries = dir.listSync(recursive: isRecursive).where(
      (entity) {
        if (entity is Directory) {
          try {
            entity.listSync();
            return true;
          } catch (_) {
            return false;
          }
        }
        return isAudioFile(entity.path);
      },
    ).toList();
    final songMetadata = await _getMetadataForEntries(entries);
    entries.sort(songSortFn(songMetadata));
    return (entries, songMetadata);
  }

  Future<Map<String, Metadata?>> _getMetadataForEntries(
    List<FileSystemEntity> entries,
  ) async {
    final songMetadata = <String, Metadata?>{};
    final metadataFutures = <Future<void>>[];
    for (var entry in entries) {
      if (entry is File) {
        final future = _getMetadata(entry).then((metadata) {
          songMetadata[entry.path] = metadata;
        });
        metadataFutures.add(future);
      }
    }
    await Future.wait(metadataFutures);
    return songMetadata;
  }
}

SongListStore useSongListStore() => create(() => SongListStore());
