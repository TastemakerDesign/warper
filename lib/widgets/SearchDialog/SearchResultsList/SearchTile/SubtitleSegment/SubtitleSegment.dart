import "dart:io";

import "package:flutter/material.dart";
import "package:flutter_media_metadata/flutter_media_metadata.dart";
import "package:warper/CustomTheme.dart";
import "package:warper/functions/getAlbumName.dart";

class SubtitleSegment extends StatelessWidget {
  SubtitleSegment({
    required this.song,
    required this.isSelected,
  });

  final Metadata? song;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final filePath = song?.filePath;
    final albumName = filePath == null ? null : getAlbumName(File(filePath));

    return Text(
      albumName ?? "Unknown Album",
      style: TextStyle(
        color: CustomTheme.gray7,
      ),
    );
  }
}
