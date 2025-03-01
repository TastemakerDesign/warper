import "dart:io";

import "package:flutter/material.dart";
import "package:flutter_media_metadata/flutter_media_metadata.dart";
import "package:flutter_zustand/flutter_zustand.dart";
import "package:warper/stores/CurrentlyPlayingStore.dart";
import "package:warper/widgets/FileTile/LeadingSegment/StatusButtonDisplay/StatusButtonDisplay.dart";
import "package:warper/widgets/FileTile/LeadingSegment/TrackNumberDisplay/TrackNumberDisplay.dart";

class LeadingSegment extends StatelessWidget {
  final ValueNotifier<bool> isHovered;
  final FileSystemEntity fileSystemEntity;
  final bool isSelected;
  final Metadata? metadata;

  LeadingSegment({
    required this.isHovered,
    required this.fileSystemEntity,
    required this.isSelected,
    required this.metadata,
  });

  @override
  Widget build(BuildContext context) {
    final currentlyPlayingStore = useCurrentlyPlayingStore();
    final (fileSystemEntity, isPlaying) = currentlyPlayingStore.select(
      context,
      (state) => (state.fileSystemEntity, state.isPlaying),
    );
    final isCurrentlyPlayingSong =
        fileSystemEntity?.path == this.fileSystemEntity.path;
    final shouldShowPause =
        isHovered.value && isPlaying && isCurrentlyPlayingSong;
    final shouldShowPlay = isHovered.value &&
        ((!isCurrentlyPlayingSong) || (isCurrentlyPlayingSong && !isPlaying));
    final shouldShowBars = isPlaying && isCurrentlyPlayingSong;
    final shouldShowTrackNumber =
        !(shouldShowPause || shouldShowPlay || shouldShowBars);

    return SizedBox(
      width: 48.0,
      child: shouldShowTrackNumber
          ? TrackNumberDisplay(
              isSelected: isSelected,
              metadata: metadata,
            )
          : StatusButtonDisplay(
              fileSystemEntity: this.fileSystemEntity,
              shouldShowBars: shouldShowBars,
              shouldShowPause: shouldShowPause,
            ),
    );
  }
}
