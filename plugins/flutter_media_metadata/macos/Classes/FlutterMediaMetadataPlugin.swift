import Cocoa
import FlutterMacOS

public class FlutterMediaMetadataPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "flutter_media_metadata", binaryMessenger: registrar.messenger)
    let instance = FlutterMediaMetadataPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {

    // TODO This code needs to be massively refactored to be on par with Apple Music.
    case "SetTrackNumber":
      guard let arguments = call.arguments as? [String: Any],
        let filePath = arguments["filePath"] as? String,
        let trackNumber = arguments["trackNumber"] as? String
      else {
        return
      }
      Task {
        let retriever = await MetadataRetriever(filePath)
        retriever.setTrackNumber(trackNumber)
        DispatchQueue.main.async {
          result(nil)
        }
      }
    case "MetadataRetriever":
      guard let arguments = call.arguments as? [String: Any],
        let filePath = arguments["filePath"] as? String
      else {
        result(
          FlutterError(
            code: "INVALID_ARGUMENTS", message: "Invalid arguments received", details: nil))
        return
      }

      Task {
        let retriever = await MetadataRetriever(filePath)

        var response: [String: Any] = [:]
        response["metadata"] = retriever.getMetadata()
        response["albumArt"] = retriever.getAlbumArt()

        DispatchQueue.main.async {
          result(response)
        }
      }

    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
