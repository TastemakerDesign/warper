import "dart:io";

import "package:path/path.dart" as p;

String getAlbumName(FileSystemEntity fileSystemEntity) {
  return p.basename(fileSystemEntity.parent.path);
}
