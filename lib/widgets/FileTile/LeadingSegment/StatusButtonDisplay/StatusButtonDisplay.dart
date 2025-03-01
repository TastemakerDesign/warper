import "dart:io";

import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_zustand/flutter_zustand.dart";
import "package:warper/CustomTheme.dart";
import "package:warper/stores/CurrentlyPlayingStore.dart";
import "package:warper/stores/FileHighlightingStore.dart";
import "package:warper/stores/WindowFocusStore.dart";

class StatusButtonDisplay extends StatelessWidget {
  final bool shouldShowPause;
  final bool shouldShowBars;
  final FileSystemEntity fileSystemEntity;

  StatusButtonDisplay({
    required this.shouldShowPause,
    required this.shouldShowBars,
    required this.fileSystemEntity,
  });

  @override
  Widget build(BuildContext context) {
    final windowFocusStore = useWindowFocusStore();
    final isWindowFocused = windowFocusStore.select(
          context,
          (state) => state.isWindowFocused,
        ) ??
        false;

    Widget child;
    switch ((shouldShowPause, shouldShowBars, isWindowFocused)) {
      case (true, _, _):
        child = Icon(
          Icons.pause,
          color: CustomTheme.gray8,
        );
      case (false, false, _):
        child = Icon(
          Icons.play_arrow,
          color: CustomTheme.gray8,
        );
      // Disable the animation when the window isn't focused to save on CPU.
      case (false, true, false):
        child = Icon(
          Icons.bar_chart,
          color: CustomTheme.blue2,
        );
      case (false, true, true):
        child = Icon(
          Icons.bar_chart,
          color: CustomTheme.blue2,
        )
            .animate(
              onPlay: (controller) => isWindowFocused
                  ? controller.repeat(reverse: true)
                  : controller.stop(),
            )
            .fadeOut(
              duration: Duration(seconds: 1),
              delay: Duration(milliseconds: 100),
              curve: Curves.easeInOut,
            );
    }

    return GestureDetector(
      onTap: () async => await _handleTap(),
      child: child,
    );
  }

  Future<void> _handleTap() async {
    final currentlyPlayingStore = useCurrentlyPlayingStore();
    final currentlyPlaying = currentlyPlayingStore.state;
    final fileHighlightingStore = useFileHighlightingStore();
    await fileHighlightingStore.highlightClickedEntry(
      fileSystemEntity,
    );
    if (currentlyPlaying.isPlaying &&
        currentlyPlaying.fileSystemEntity?.path == fileSystemEntity.path) {
      await currentlyPlayingStore.pauseSong();
    } else if (currentlyPlaying.fileSystemEntity?.path ==
        fileSystemEntity.path) {
      await currentlyPlayingStore.resumeSong();
    } else {
      await currentlyPlayingStore.playSong(fileSystemEntity);
    }
  }
}
