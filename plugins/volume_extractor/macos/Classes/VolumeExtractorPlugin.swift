import AVFoundation
import Cocoa
import FlutterMacOS

public class VolumeExtractorPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "volume_extractor", binaryMessenger: registrar.messenger)
    let instance = VolumeExtractorPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if call.method == "extractVolumeData" {
      guard let args = call.arguments as? [String: Any],
        let filePath = args["filePath"] as? String,
        let interval = args["interval"] as? Double
      else {
        result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil))
        return
      }

      let fileURL = URL(fileURLWithPath: filePath)

      // Run extraction in a background thread to avoid UI blocking
      DispatchQueue.global(qos: .userInitiated).async {
        let volumeData = self.extractVolumeData(from: fileURL)

        // Return result to Flutter on the main thread
        DispatchQueue.main.async {
          result(volumeData)
        }
      }
    } else {
      result(FlutterMethodNotImplemented)
    }
  }

  private func extractVolumeData(from fileURL: URL) -> [Float] {
    do {
      let audioFile = try AVAudioFile(forReading: fileURL)
      let format = audioFile.processingFormat
      let frameCount = Int(audioFile.length)

      guard
        let buffer = AVAudioPCMBuffer(
          pcmFormat: format, frameCapacity: AVAudioFrameCount(frameCount))
      else {
        return []
      }

      try audioFile.read(into: buffer)

      guard let floatChannelData = buffer.floatChannelData else {
        return []
      }

      let sampleCount = Int(buffer.frameLength)
      let selectedChannel = 0  // Use only the first channel

      // Determine the number of samples to take
      let maxSamples = 2500
      let numSamplesToTake = min(sampleCount, maxSamples)

      var volumeData: [Float] = []

      if numSamplesToTake == sampleCount {
        // If there are fewer samples than maxSamples, take them all
        let samples = UnsafeBufferPointer(
          start: floatChannelData[selectedChannel], count: sampleCount)
        volumeData = samples.map { abs($0) }
      } else {
        // Otherwise, take maxSamples evenly spaced
        let stepSize = sampleCount / numSamplesToTake
        let samples = UnsafeBufferPointer(
          start: floatChannelData[selectedChannel], count: sampleCount)

        for i in 0..<numSamplesToTake {
          let index = i * stepSize
          volumeData.append(abs(samples[index]))
        }
      }

      return volumeData
    } catch {
      print("Error loading audio file: \(error)")
      return []
    }
  }
}
