import "dart:io";

import "package:flutter/material.dart";
import "package:flutter_media_metadata/flutter_media_metadata.dart";
import "package:warper/CustomTheme.dart";
import "package:warper/functions/getSongTitle.dart";

class TitleSegment extends StatelessWidget {
  TitleSegment({
    required this.song,
  });

  final Metadata? song;

  @override
  Widget build(BuildContext context) {
    final filePath = song?.filePath;
    final songTitle = filePath == null ? null : getSongTitle(File(filePath));

    return Text(
      songTitle ?? "Unknown Title",
      style: TextStyle(
        color: CustomTheme.gray8,
      ),
    );
  }
}
