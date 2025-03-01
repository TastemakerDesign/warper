Duration convertFramesToDuration(int n) {
  // Assume that Flutter is rendering slightly slowly on the user's device.
  return Duration(milliseconds: (16.667 * n).round());
}
