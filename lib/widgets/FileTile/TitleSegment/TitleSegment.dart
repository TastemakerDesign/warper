import "dart:io";

import "package:flutter/material.dart";
import "package:flutter_media_metadata/flutter_media_metadata.dart";
import "package:warper/CustomTheme.dart";
import "package:warper/functions/getSongTitle.dart";

class TitleSegment extends StatelessWidget {
  final bool isSelected;
  final FileSystemEntity fileSystemEntity;
  final Metadata? metadata;

  TitleSegment({
    required this.isSelected,
    required this.fileSystemEntity,
    required this.metadata,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      getSongTitle(fileSystemEntity),
      style: TextStyle(
        fontSize: 14.0,
        color: isSelected ? CustomTheme.white : CustomTheme.gray8,
      ),
    );
  }
}
