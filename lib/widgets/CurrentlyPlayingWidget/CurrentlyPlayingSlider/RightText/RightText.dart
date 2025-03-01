import "package:flutter/material.dart";
import "package:flutter_zustand/flutter_zustand.dart";
import "package:warper/CustomTheme.dart";
import "package:warper/functions/formatDuration.dart";
import "package:warper/stores/CurrentlyPlayingStore.dart";

class RightText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentlyPlayingStore = useCurrentlyPlayingStore();
    final (duration, fileSystemEntity) = currentlyPlayingStore.select(
      context,
      (state) => (state.duration, state.fileSystemEntity),
    );

    return Text(
      formatDuration(
        fileSystemEntity == null ? null : duration.inMilliseconds,
      ),
      textAlign: TextAlign.left,
      style: TextStyle(
        color: CustomTheme.gray8,
        fontSize: 12.0,
      ),
    );
  }
}
