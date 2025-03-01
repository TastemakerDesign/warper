import "package:flutter/material.dart";
import "package:flutter_zustand/flutter_zustand.dart";
import "package:warper/CustomTheme.dart";
import "package:warper/functions/formatDuration.dart";
import "package:warper/stores/CurrentlyPlayingStore.dart";

class LeftText extends StatelessWidget {
  final ValueNotifier<double?> sliderValue;

  LeftText({
    required this.sliderValue,
  });

  @override
  Widget build(BuildContext context) {
    final currentlyPlayingStore = useCurrentlyPlayingStore();
    final (fileSystemEntity, position) = currentlyPlayingStore.select(
      context,
      (state) => (state.fileSystemEntity, state.position),
    );
    double currentPosition =
        sliderValue.value ?? (position.inMilliseconds / 1000).toDouble();

    return Text(
      formatDuration(
        fileSystemEntity == null
            ? null
            : Duration(seconds: currentPosition.toInt()).inMilliseconds,
      ),
      textAlign: TextAlign.right,
      style: TextStyle(
        color: CustomTheme.gray8,
        fontSize: 12.0,
      ),
    );
  }
}
