import "package:flutter/material.dart";
import "package:flutter_zustand/flutter_zustand.dart";
import "package:warper/CustomTheme.dart";
import "package:warper/stores/CurrentlyPlayingStore.dart";

class NextSongButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentlyPlayingStore = useCurrentlyPlayingStore();
    final fileSystemEntity = currentlyPlayingStore.select(
      context,
      (state) => state.fileSystemEntity,
    );

    return Tooltip(
      message: "Next Song [⌘ ⇧ Right]",
      waitDuration: Duration(seconds: 1),
      child: IconButton(
        onPressed: fileSystemEntity == null
            ? null
            : () async => await _handlePressed(),
        color: CustomTheme.gray7,
        disabledColor: CustomTheme.gray7,
        icon: Icon(
          Icons.fast_forward,
        ),
        iconSize: 32.0,
      ),
    );
  }

  Future<void> _handlePressed() async {
    final currentlyPlayingStore = useCurrentlyPlayingStore();
    await currentlyPlayingStore.playNextSong();
  }
}
