// ignore_for_file: no_dart_files_with_more_than_200_lines_of_code
import "dart:io";

import "package:flutter/services.dart";
import "package:warper/functions/handleFileEntityAction.dart";
import "package:warper/functions/navigateUpwardsAction.dart";
import "package:warper/functions/shortcuts/ActionType.dart";
import "package:warper/stores/CurrentFolderStore.dart";
import "package:warper/stores/CurrentlyPlayingStore.dart";
import "package:warper/stores/FileHighlightingStore.dart";
import "package:warper/stores/MetadataDialogStore.dart";
import "package:warper/stores/SearchQueryStore.dart";
import "package:warper/stores/ShortcutsDialogStore.dart";
import "package:window_manager/window_manager.dart";

final List<ActionType> normalKeyPressActions = [
  (
    name: "Highlight Next Entry",
    shortcuts: [
      (LogicalKeyboardKey.arrowDown, false, false, false),
      (LogicalKeyboardKey.tab, false, false, false),
    ],
    action: () async {
      final fileHighlightingStore = useFileHighlightingStore();
      await fileHighlightingStore.highlightEntryFromKeyPress(
        HighlightingOption.next,
      );
    },
  ),
  (
    name: "Highlight Previous Entry",
    shortcuts: [
      (LogicalKeyboardKey.arrowUp, false, false, false),
      (LogicalKeyboardKey.tab, false, true, false),
    ],
    action: () async {
      final fileHighlightingStore = useFileHighlightingStore();
      await fileHighlightingStore.highlightEntryFromKeyPress(
        HighlightingOption.previous,
      );
    },
  ),
  (
    name: "Highlight Page Down Entry",
    shortcuts: [
      (LogicalKeyboardKey.pageDown, false, false, false),
    ],
    action: () async {
      final fileHighlightingStore = useFileHighlightingStore();
      await fileHighlightingStore.highlightEntryFromKeyPress(
        HighlightingOption.pageDown,
      );
    },
  ),
  (
    name: "Highlight Page Up Entry",
    shortcuts: [
      (LogicalKeyboardKey.pageUp, false, false, false),
    ],
    action: () async {
      final fileHighlightingStore = useFileHighlightingStore();
      await fileHighlightingStore.highlightEntryFromKeyPress(
        HighlightingOption.pageUp,
      );
    },
  ),
  (
    name: "Highlight Last Entry",
    shortcuts: [
      (LogicalKeyboardKey.end, false, false, false),
    ],
    action: () async {
      final fileHighlightingStore = useFileHighlightingStore();
      await fileHighlightingStore.highlightEntryFromKeyPress(
        HighlightingOption.end,
      );
    },
  ),
  (
    name: "Highlight First Entry",
    shortcuts: [
      (LogicalKeyboardKey.home, false, false, false),
    ],
    action: () async {
      final fileHighlightingStore = useFileHighlightingStore();
      await fileHighlightingStore.highlightEntryFromKeyPress(
        HighlightingOption.home,
      );
    },
  ),
  (
    name: "Open Folder / Play Song",
    shortcuts: [
      (LogicalKeyboardKey.arrowDown, true, false, false),
      (LogicalKeyboardKey.enter, false, false, false),
    ],
    action: () async {
      await handleFileEntityAction();
    },
  ),
  (
    name: "Navigate Upwards",
    shortcuts: [
      (LogicalKeyboardKey.arrowUp, true, false, false),
      (LogicalKeyboardKey.arrowLeft, true, false, false),
    ],
    action: () async {
      await navigateUpwardsAction();
    },
  ),
  (
    name: "Play/Pause Currently Playing",
    shortcuts: [
      (LogicalKeyboardKey.space, false, false, false),
    ],
    action: () async {
      final currentlyPlayingStore = useCurrentlyPlayingStore();
      await currentlyPlayingStore.playPauseButtonPressed();
    },
  ),
  (
    name: "Navigate to Currently Playing Folder",
    shortcuts: [
      (LogicalKeyboardKey.keyL, true, false, false),
    ],
    action: () async {
      final currentlyPlayingStore = useCurrentlyPlayingStore();
      await currentlyPlayingStore.navigateToCurrentlyPlayingFolder();
    },
  ),
  (
    name: "Pause Currently Playing and Close Window",
    shortcuts: [
      (LogicalKeyboardKey.keyW, true, false, false),
    ],
    action: () async {
      await windowManager.close();
    },
  ),
  (
    name: "Play Next Song",
    shortcuts: [
      (LogicalKeyboardKey.arrowRight, true, true, false),
    ],
    action: () async {
      final currentlyPlayingStore = useCurrentlyPlayingStore();
      await currentlyPlayingStore.playNextSong();
    },
  ),
  (
    name: "Play Previous Song",
    shortcuts: [
      (LogicalKeyboardKey.arrowLeft, true, true, false),
    ],
    action: () async {
      final currentlyPlayingStore = useCurrentlyPlayingStore();
      await currentlyPlayingStore.playPreviousSong();
    },
  ),
  (
    name: "Seek Forward 5 Seconds",
    shortcuts: [
      (LogicalKeyboardKey.arrowRight, false, false, false),
    ],
    action: () async {
      final currentlyPlayingStore = useCurrentlyPlayingStore();
      final currentPosition = currentlyPlayingStore.state.position;
      final songDuration = currentlyPlayingStore.state.duration;
      final newPosition = currentPosition + Duration(seconds: 5);
      await currentlyPlayingStore.seekTo(
        newPosition < songDuration ? newPosition : songDuration,
      );
    },
  ),
  (
    name: "Seek Backward 5 Seconds",
    shortcuts: [
      (LogicalKeyboardKey.arrowLeft, false, false, false),
    ],
    action: () async {
      final currentlyPlayingStore = useCurrentlyPlayingStore();
      final currentPosition = currentlyPlayingStore.state.position;
      final newPosition = currentPosition - Duration(seconds: 5);
      await currentlyPlayingStore.seekTo(
        newPosition > Duration.zero ? newPosition : Duration.zero,
      );
    },
  ),
  (
    name: "Show Metadata Dialog",
    shortcuts: [
      (LogicalKeyboardKey.keyI, true, false, false),
    ],
    action: () {
      final fileHighlightingStore = useFileHighlightingStore();
      final metadataDialogStore = useMetadataDialogStore();
      final currentlySelected = fileHighlightingStore.state.currentlySelected;
      if (currentlySelected == null || currentlySelected is Directory) {
        return;
      }
      metadataDialogStore.showDialog(currentlySelected.path);
    },
  ),
  (
    name: "Show Search Dialog",
    shortcuts: [
      (LogicalKeyboardKey.keyP, true, false, false),
      (LogicalKeyboardKey.keyF, true, false, false),
    ],
    action: () {
      final searchQueryStore = useSearchQueryStore();
      searchQueryStore.showSearchDialog();
    },
  ),
  (
    name: "Show Keyboard Shortcuts Dialog",
    shortcuts: [
      (LogicalKeyboardKey.slash, true, false, false),
    ],
    action: () {
      final shortcutsDialogStore = useShortcutsDialogStore();
      shortcutsDialogStore.showDialog();
    },
  ),
  (
    name: "Open Music Folder",
    shortcuts: [
      (LogicalKeyboardKey.keyO, true, false, false),
    ],
    action: () async {
      final currentFolderStore = useCurentFolderStore();
      final isPicking = currentFolderStore.state.isPicking;
      if (!isPicking) {
        await currentFolderStore.pickFolder();
      }
    },
  ),
];
