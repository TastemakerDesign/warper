import "dart:async";
import "dart:io";
import "dart:math";

import "package:flutter/material.dart";
import "package:flutter_zustand/flutter_zustand.dart";
import "package:warper/functions/convertFramesToDuration.dart";
import "package:warper/stores/SongListStore.dart";

enum HighlightingOption {
  next,
  pageDown,
  end,
  previous,
  pageUp,
  home,
}

class FileHighlightingStore
    extends Store<({FileSystemEntity? currentlySelected})> {
  FileHighlightingStore() : super((currentlySelected: null));

  static final animationRestart = ValueNotifier(1.0);
  static final scrollController = ScrollController();

  Future<void> highlightEntryFromTeleport(
    FileSystemEntity? newSelection,
    bool shouldScrollToTop,
  ) async {
    set(
      (currentlySelected: null),
    );
    if (newSelection == null) {
      return;
    }
    animationRestart.value = 0.01;
    // For some unknown reason, a slightly larger delay is needed when
    // teleporting if no song has been played before.
    Future.delayed(convertFramesToDuration(5), () async {
      set(
        (currentlySelected: newSelection),
      );
      try {
        if (shouldScrollToTop) {
          // Avoid triggering an exception when the folder is empty.
          if (scrollController.positions.length != 0) {
            scrollController.jumpTo(0);
          }
          return;
        }
        final songListStore = useSongListStore();
        final songList = songListStore.state.songList;
        if (songList == null || songList.isEmpty) {
          return;
        }
        if (state.currentlySelected == null) {
          return;
        }
        int index = songList.indexWhere(
          (element) => element.path == newSelection.path,
        );
        if (index == -1) {
          return;
        }
        final maxPosition = scrollController.position.maxScrollExtent;
        scrollController.jumpTo((60.0 * index).clamp(0, maxPosition));
        final globalKey =
            songListStore.getGlobalKeyForSong(songList[index].path);
        if (globalKey.currentContext == null) {
          return;
        }
        await Scrollable.ensureVisible(
          globalKey.currentContext!,
          alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
        );
      } finally {
        for (int i = 0; i < 40; i++) {
          await Future.delayed(Duration(milliseconds: 1));
          animationRestart.value += 0.025;
        }
      }
    });
  }

  Future<void> highlightClickedEntry(FileSystemEntity? newSelection) async {
    set(
      (currentlySelected: newSelection),
    );
  }

  Future<void> highlightEntryFromKeyPress(HighlightingOption option) async {
    final songListStore = useSongListStore();
    final songList = songListStore.state.songList;
    if (songList == null || songList.isEmpty) {
      return;
    }
    int currentIndex = songList
        .indexWhere((element) => element.path == state.currentlySelected?.path);
    if (currentIndex == -1 && option == HighlightingOption.previous) {
      currentIndex = 0;
    }
    int newIndex;
    switch (option) {
      case HighlightingOption.next:
        newIndex = (currentIndex + 1) % songList.length;
        await _scrollIntoView(newIndex, false);
      case HighlightingOption.pageDown:
        newIndex = min(songList.length - 1, currentIndex + 13);
        await _scrollIntoView(newIndex, true);
      case HighlightingOption.end:
        newIndex = songList.length - 1;
        await _scrollIntoView(newIndex, true);
      case HighlightingOption.previous:
        newIndex = (currentIndex - 1) % songList.length;
        await _scrollIntoView(newIndex, false);
      case HighlightingOption.pageUp:
        newIndex = max(0, currentIndex - 13);
        await _scrollIntoView(newIndex, true);
      case HighlightingOption.home:
        newIndex = 0;
        await _scrollIntoView(newIndex, true);
    }
    final globalKey =
        songListStore.getGlobalKeyForSong(songList[newIndex].path);
    if (globalKey.currentContext == null) {
      return;
    }
    // Needed for correct wraparound behavior.
    switch (option) {
      case HighlightingOption.next:
      case HighlightingOption.pageDown:
      case HighlightingOption.end:
        await Scrollable.ensureVisible(
          globalKey.currentContext!,
          alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtStart,
        );
        await Scrollable.ensureVisible(
          globalKey.currentContext!,
          alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
        );
      case HighlightingOption.previous:
      case HighlightingOption.pageUp:
      case HighlightingOption.home:
        await Scrollable.ensureVisible(
          globalKey.currentContext!,
          alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
        );
        await Scrollable.ensureVisible(
          globalKey.currentContext!,
          alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtStart,
        );
    }
    set(
      (currentlySelected: songList[newIndex]),
    );
  }

  Future<void> _scrollIntoView(int index, bool jumpUnconditionally) async {
    final topSegmentHeight = 76.0 + 64.0;
    final tileHeight = 60.0;
    final scrollOffset = scrollController.offset;
    final screenHeight =
        scrollController.position.viewportDimension - topSegmentHeight;
    final heightDifference = scrollOffset - tileHeight * index;
    final conditional1 = (heightDifference > 0) &&
        (heightDifference.abs() > (screenHeight + 0.5 * tileHeight));
    final conditional2 = (heightDifference < 0) &&
        (heightDifference.abs() > (screenHeight + 3.0 * tileHeight));
    if (jumpUnconditionally || conditional1 || conditional2) {
      final maxPosition = scrollController.position.maxScrollExtent;
      scrollController.jumpTo((tileHeight * index).clamp(0, maxPosition));
      await Future.delayed(convertFramesToDuration(3));
    }
  }
}

FileHighlightingStore useFileHighlightingStore() =>
    create(() => FileHighlightingStore());
