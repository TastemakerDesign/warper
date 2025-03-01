
import 'volume_extractor_platform_interface.dart';

class VolumeExtractor {
  Future<String?> getPlatformVersion() {
    return VolumeExtractorPlatform.instance.getPlatformVersion();
  }
}
