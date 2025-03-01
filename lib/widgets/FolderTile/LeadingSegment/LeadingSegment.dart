import "dart:io";

import "package:flutter/material.dart";
import "package:warper/CustomTheme.dart";

class LeadingSegment extends StatelessWidget {
  final String? imagePath;
  final double thumbnailSize;

  LeadingSegment({
    required this.imagePath,
    required this.thumbnailSize,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: thumbnailSize,
      height: thumbnailSize,
      child: imagePath != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: Image.file(
                File(imagePath!),
                width: thumbnailSize,
                height: thumbnailSize,
                fit: BoxFit.cover,
              ),
            )
          : Container(
              width: thumbnailSize,
              height: thumbnailSize,
              alignment: Alignment.center,
              child: Icon(
                Icons.folder,
                size: thumbnailSize * 0.8,
                color: CustomTheme.gray7,
              ),
            ),
    );
  }
}
