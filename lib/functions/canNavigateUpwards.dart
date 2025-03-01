import "dart:io";

bool canNavigateUpwards(String directory) {
  final parentDir = Directory(directory).parent;
  try {
    parentDir.listSync();
  } catch (_) {
    return false;
  }
  return true;
}
