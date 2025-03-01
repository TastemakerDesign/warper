import "package:flutter/material.dart";
import "package:flutter_media_metadata/flutter_media_metadata.dart";
import "package:warper/CustomTheme.dart";

class TrackNumberDisplay extends StatelessWidget {
  final bool isSelected;
  final Metadata? metadata;

  TrackNumberDisplay({
    required this.isSelected,
    required this.metadata,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      metadata?.trackNumber?.toString() ?? "",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 14.0,
        color: isSelected ? CustomTheme.blue2 : CustomTheme.gray7,
      ),
    );
  }
}
