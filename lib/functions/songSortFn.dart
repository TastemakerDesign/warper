import "dart:io";

import "package:collection/collection.dart";
import "package:flutter_media_metadata/flutter_media_metadata.dart";

int Function(FileSystemEntity, FileSystemEntity) songSortFn(
  Map<String, Metadata?> songMetadata,
) {
  int _songSortFnInternal(FileSystemEntity a, FileSystemEntity b) {
    final isADir = a is Directory;
    final isBDir = b is Directory;
    if (isADir && !isBDir) {
      return -1;
    }
    if (!isADir && isBDir) {
      return 1;
    }
    if (isADir && isBDir) {
      return compareNatural(a.path.toLowerCase(), b.path.toLowerCase());
    }
    final metadataA = songMetadata[a.path];
    final metadataB = songMetadata[b.path];
    final trackA = metadataA?.trackNumber ?? 0;
    final trackB = metadataB?.trackNumber ?? 0;
    if (trackA != trackB) {
      return trackA.compareTo(trackB);
    }
    return compareNatural(a.path.toLowerCase(), b.path.toLowerCase());
  }

  return _songSortFnInternal;
}
