/// This file is a part of flutter_media_metadata (https://github.com/alexmercerind/flutter_media_metadata).
///
/// Copyright (c) 2021-2022, Hitesh Kumar Saini <saini123hitesh@gmail.com>.
/// All rights reserved.
/// Use of this source code is governed by MIT license that can be found in the LICENSE file.

import 'dart:io';
import 'package:flutter/services.dart';

import 'package:flutter_media_metadata/src/models/metadata.dart';

/// ## MetadataRetriever
///
/// Use [MetadataRetriever.fromFile] to extract [Metadata] from a media file.
///
/// ```dart
/// final metadata = MetadataRetriever.fromFile(file);
/// String? trackName = metadata.trackName;
/// List<String>? trackArtistNames = metadata.trackArtistNames;
/// String? albumName = metadata.albumName;
/// String? albumArtistName = metadata.albumArtistName;
/// int? trackNumber = metadata.trackNumber;
/// int? albumLength = metadata.albumLength;
/// int? year = metadata.year;
/// String? genre = metadata.genre;
/// String? authorName = metadata.authorName;
/// String? writerName = metadata.writerName;
/// int? discNumber = metadata.discNumber;
/// String? mimeType = metadata.mimeType;
/// int? trackDuration = metadata.trackDuration;
/// int? bitrate = metadata.bitrate;
/// Uint8List? albumArt = metadata.albumArt;
/// ```
///
class MetadataRetriever {
  static Future<Metadata> fromFile(File file) async {
    var metadata = await _kChannel.invokeMethod(
      'MetadataRetriever',
      {
        'filePath': file.path,
      },
    );
    metadata['filePath'] = file.path;
    return Metadata.fromJson(metadata);
  }

  static Future<void> setTrackNumber(File file, String trackNumber) async {
    await _kChannel.invokeMethod(
      'SetTrackNumber',
      {
        'filePath': file.path,
        'trackNumber': trackNumber,
      },
    );
  }
}

var _kChannel = const MethodChannel('flutter_media_metadata');
