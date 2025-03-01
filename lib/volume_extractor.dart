import "dart:async";

import "package:flutter/services.dart";

class VolumeExtractor {
  static final MethodChannel _channel = MethodChannel("volume_extractor");

  static Future<List<double>> extractVolumeData(
    String filePath, {
    double interval = 0.5,
  }) async {
    final dynamic result = await _channel.invokeMethod("extractVolumeData", {
      "filePath": filePath,
      "interval": interval,
    });
    return (result as List<dynamic>).cast<double>();
  }
}
