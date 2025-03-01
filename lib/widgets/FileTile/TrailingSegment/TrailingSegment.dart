import "package:flutter/material.dart";
import "package:flutter_media_metadata/flutter_media_metadata.dart";
import "package:warper/CustomTheme.dart";
import "package:warper/functions/formatDuration.dart";

class TrailingSegment extends StatelessWidget {
  final bool isSelected;
  final Metadata? metadata;

  TrailingSegment({
    required this.isSelected,
    required this.metadata,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      formatDuration(metadata?.trackDuration),
      style: TextStyle(
        fontSize: 14.0,
        color: isSelected ? CustomTheme.blue2 : CustomTheme.gray7,
      ),
    );
  }
}
