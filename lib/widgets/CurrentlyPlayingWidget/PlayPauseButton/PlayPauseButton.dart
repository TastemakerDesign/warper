import "package:flutter/material.dart";
import "package:flutter_zustand/flutter_zustand.dart";
import "package:warper/CustomTheme.dart";
import "package:warper/stores/CurrentlyPlayingStore.dart";

class PlayPauseButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentlyPlayingStore = useCurrentlyPlayingStore();
    final fileSystemEntity = currentlyPlayingStore.select(
      context,
      (state) => state.fileSystemEntity,
    );
    final isPlaying = currentlyPlayingStore.select(
      context,
      (state) => state.isPlaying,
    );

    return Tooltip(
      message: isPlaying ? "Pause [Space]" : "Play [Space]",
      waitDuration: Duration(seconds: 1),
      child: IconButton(
        onPressed: fileSystemEntity == null
            ? null
            : () async => await _handlePressed(),
        color: CustomTheme.gray7,
        disabledColor: CustomTheme.gray7,
        icon: Icon(
          isPlaying ? Icons.pause : Icons.play_arrow,
        ),
        iconSize: 32.0,
      ),
    );
  }

  Future<void> _handlePressed() async {
    final currentlyPlayingStore = useCurrentlyPlayingStore();
    await currentlyPlayingStore.playPauseButtonPressed();
  }
}
