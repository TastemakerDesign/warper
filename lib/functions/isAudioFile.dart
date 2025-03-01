bool isAudioFile(String path) {
  final supportedExtensions = [
    ".aac",
    ".aiff",
    ".flac",
    ".mp3",
    ".wav",
  ];
  return supportedExtensions.any((ext) => path.endsWith(ext));
}
