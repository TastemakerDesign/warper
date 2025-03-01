import "package:flutter/material.dart";
import "package:flutter_media_metadata/flutter_media_metadata.dart";
import "package:warper/CustomTheme.dart";

class LeadingSegment extends StatelessWidget {
  LeadingSegment({
    required this.song,
  });

  final Metadata? song;

  @override
  Widget build(BuildContext context) {
    final albumArt = song?.albumArt;

    return Container(
      color: CustomTheme.gray5,
      width: 48.0,
      height: 48.0,
      child: albumArt != null
          ? Image.memory(
              albumArt,
              width: 48.0,
              height: 48.0,
              fit: BoxFit.cover,
            )
          : Icon(
              Icons.music_note,
              color: CustomTheme.gray8,
            ),
    );
  }
}
