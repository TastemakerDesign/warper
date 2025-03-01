import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'volume_extractor_platform_interface.dart';

/// An implementation of [VolumeExtractorPlatform] that uses method channels.
class MethodChannelVolumeExtractor extends VolumeExtractorPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('volume_extractor');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
