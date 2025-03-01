import AVFoundation
import Foundation
import ID3TagEditor

#if os(macOS)
  import CoreServices
#elseif os(iOS)
  import MobileCoreServices
#endif

protocol MetadataRetrieverProtocol {
  func getTrackName() -> String?
  func getArtistNames() -> String?
  func getAlbumName() -> String?
  func getAlbumArtistName() -> String?
  func getTrackNumber() -> String?
  func getAlbumLength() -> String?
  func getYear() -> String?
  func getGenre() -> String?
  func getAuthorName() -> String?
  func getWriterName() -> String?
  func getDiscNumber() -> String?
  func getAlbumArt() -> Data?
}

public class MetadataRetriever {
  let filePath: String
  let url: URL
  let asset: AVAsset
  let preferredRetriever: MetadataRetrieverProtocol?

  init(_ filePath: String) async {
    self.filePath = filePath
    self.url = URL(fileURLWithPath: self.filePath)

    let asset = AVAsset(url: url)
    let preferredRetriever: MetadataRetrieverProtocol? = await {
      if asset.availableMetadataFormats.contains(.id3Metadata) {
        return await Id3MetadataRetriever(asset.metadata(forFormat: .id3Metadata))
      }

      if asset.availableMetadataFormats.contains(.iTunesMetadata) {
        return ItunesMetadataRetriever(asset.metadata(forFormat: .iTunesMetadata))
      }

      return nil
    }()

    self.asset = asset
    self.preferredRetriever = preferredRetriever
  }

  public func getMetadata() -> [String: Any] {
    var metadata: [String: Any] = [:]

    metadata["trackName"] = getTrackName()
    metadata["trackArtistNames"] = getArtistNames()
    metadata["albumName"] = getAlbumName()
    metadata["albumArtistName"] = getAlbumArtistName()
    metadata["trackNumber"] = getTrackNumber()
    metadata["albumLength"] = getAlbumLength()
    metadata["year"] = getYear()
    metadata["genre"] = getGenre()
    metadata["authorName"] = getAuthorName()
    metadata["writerName"] = getWriterName()
    metadata["discNumber"] = getDiscNumber()
    metadata["mimeType"] = getMimeType()
    metadata["trackDuration"] = getDuration()
    metadata["bitrate"] = getBitrate()
    return metadata
  }

  private func getTrackName() -> String? {
    return preferredRetriever?.getTrackName()
  }

  private func getArtistNames() -> String? {
    return preferredRetriever?.getArtistNames()
  }

  private func getAlbumName() -> String? {
    return preferredRetriever?.getAlbumName()
  }

  private func getAlbumArtistName() -> String? {
    return preferredRetriever?.getAlbumArtistName()
  }

  private func getTrackNumber() -> String? {
    return preferredRetriever?.getTrackNumber()
  }

  private func getAlbumLength() -> String? {
    return preferredRetriever?.getAlbumLength()
  }

  private func getYear() -> String? {
    return preferredRetriever?.getYear()
  }

  private func getGenre() -> String? {
    return preferredRetriever?.getGenre()
  }

  private func getAuthorName() -> String? {
    return preferredRetriever?.getAuthorName()
  }

  private func getWriterName() -> String? {
    return preferredRetriever?.getWriterName()
  }

  private func getDiscNumber() -> String? {
    return preferredRetriever?.getDiscNumber()
  }

  private func getDuration() -> String {
    let milliseconds = Int(Float64(asset.duration.value * 1000) / Float64(asset.duration.timescale))
    return String(milliseconds)
  }

  private func getBitrate() -> String? {
    // NOTE: AVAssetTrack:estimatedDataRate returns 0.0 if file is mp3
    var audioFileRef: ExtAudioFileRef?
    let openFileResult = ExtAudioFileOpenURL(url as CFURL, &audioFileRef)
    guard let audioFileRef = audioFileRef, openFileResult == 0 else {
      return nil
    }

    // Ensures the resource is released
    defer { ExtAudioFileDispose(audioFileRef) }

    var audioFileID: AudioFileID?
    var propertyDataSize = UInt32(MemoryLayout<AudioFileID>.size)
    let getPropertyResult = ExtAudioFileGetProperty(
      audioFileRef, kExtAudioFileProperty_AudioFile, &propertyDataSize, &audioFileID)
    guard let audioFileID = audioFileID, getPropertyResult == 0 else {
      return nil
    }

    var bitRate: UInt32 = 0
    var bitRateSize = UInt32(MemoryLayout.size(ofValue: bitRate))
    let getBitRateResult = AudioFileGetProperty(
      audioFileID, kAudioFilePropertyBitRate, &bitRateSize, &bitRate)
    guard getBitRateResult == 0 else {
      return nil
    }
    return String(bitRate)
  }

  private func getMimeType() -> String? {
    let pathExtension = self.url.pathExtension
    guard
      let identifier = UTTypeCreatePreferredIdentifierForTag(
        kUTTagClassFilenameExtension, pathExtension as NSString, nil)?.takeRetainedValue()
    else {
      return nil
    }

    return UTTypeCopyPreferredTagWithClass(identifier, kUTTagClassMIMEType)?.takeRetainedValue()
      as? String
  }

  public func getAlbumArt() -> Data? {
    return preferredRetriever?.getAlbumArt()
  }
    
    public func setTrackNumber(_ trackNumber: String) {
        // Get the file URL
        let fileURL = URL(fileURLWithPath: self.filePath)

        // Check if the file is an MP3
        guard fileURL.pathExtension.lowercased() == "mp3" else {
            print("Not an MP3 file. Skipping metadata update.")
            return
        }

        do {
            // Create an ID3TagEditor instance
            let id3TagEditor = ID3TagEditor()

            // Parse the existing tags from the MP3 file
            let tag = try id3TagEditor.read(from: fileURL.path)
            
            // Set the track number
            tag?.frames[.trackPosition] = ID3FramePartOfTotal(part: Int(trackNumber) ?? 0, total: nil)

            // Write the updated tag to the file
            try id3TagEditor.write(tag: tag!, to: fileURL.path)
            
            print("Track number updated to \(trackNumber) successfully!")
        } catch {
            print("Error updating MP3 metadata: \(error.localizedDescription)")
            return
        }
    }


}
