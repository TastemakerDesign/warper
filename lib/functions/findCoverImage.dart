import "dart:io";

import "package:path/path.dart" as p;

Future<String?> findCoverImage(String directoryPath) async {
  final directory = Directory(directoryPath);

  try {
    if (await directory.exists()) {
      final files = directory.listSync();

      // Look for `cover.jpg` first
      final coverFile = files.firstWhere(
        (file) =>
            file is File && p.basename(file.path).toLowerCase() == "cover.jpg",
        orElse: () => File(""), // Return empty if not found
      );

      if (coverFile is File && await coverFile.exists()) {
        return coverFile.path;
      }

      // If no `cover.jpg`, look for any image file
      final imageFile = files.firstWhere(
        (file) =>
            file is File &&
            (file.path.toLowerCase().endsWith(".jpg") ||
                file.path.toLowerCase().endsWith(".jpeg") ||
                file.path.toLowerCase().endsWith(".png")),
        orElse: () => File(""),
      );

      if (imageFile is File && await imageFile.exists()) {
        return imageFile.path;
      }
    }
  } catch (_) {
    return null;
  }

  return null;
}
