String formatDuration(int? durationInMilliseconds) {
  if (durationInMilliseconds == null) {
    return "--:--";
  }
  int durationInSeconds = durationInMilliseconds ~/ 1000;
  final hours = durationInSeconds ~/ 3600;
  final minutes = (durationInSeconds % 3600) ~/ 60;
  final seconds = durationInSeconds % 60;
  if (hours > 0) {
    return "$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  } else {
    return "$minutes:${seconds.toString().padLeft(2, '0')}";
  }
}
