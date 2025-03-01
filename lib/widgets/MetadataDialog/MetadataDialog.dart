import "package:flutter/material.dart";
import "package:flutter_zustand/flutter_zustand.dart";
import "package:path/path.dart" as path;
import "package:warper/CustomTheme.dart";
import "package:warper/stores/MetadataDialogStore.dart";
import "package:warper/stores/SongListStore.dart";
import "package:warper/widgets/MetadataDialog/CloseDialogButton/CloseDialogButton.dart";
import "package:warper/widgets/MetadataDialog/MetadataItemWidget/MetadataItemWidget.dart";

class MetadataDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final metadataDialogStore = useMetadataDialogStore();
    final songListStore = useSongListStore();
    final songMetadata = songListStore.select(
      context,
      (state) => state.songMetadata,
    );
    final filePath = metadataDialogStore.select(
      context,
      (state) => state.filePath,
    );
    final metadata = songMetadata?[filePath];
    assert(metadata != null);
    assert(filePath != null);
    final fileName = path.basename(filePath!);
    final parentFolderName = path.basename(path.dirname(filePath));

    return Container(
      padding: EdgeInsets.all(32.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: CustomTheme.black,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Song Metadata",
                  style: TextStyle(
                    color: CustomTheme.white,
                    fontSize: 32.0,
                  ),
                ),
                CloseDialogButton(),
              ],
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              child: ListView(
                children: [
                  MetadataItemWidget(
                    label: "File Name",
                    value: fileName,
                    isStripedColor: true,
                  ),
                  MetadataItemWidget(
                    label: "Parent Folder Name",
                    value: parentFolderName,
                    isStripedColor: false,
                  ),
                  MetadataItemWidget(
                    label: "Track Name",
                    value: metadata!.trackName ?? "",
                    isStripedColor: true,
                  ),
                  MetadataItemWidget(
                    label: "Artist",
                    value: metadata.authorName ?? "",
                    isStripedColor: false,
                  ),
                  MetadataItemWidget(
                    label: "Album",
                    value: metadata.albumName ?? "",
                    isStripedColor: true,
                  ),
                  MetadataItemWidget(
                    label: "Album Artist",
                    value: metadata.albumArtistName ?? "",
                    isStripedColor: false,
                  ),
                  MetadataItemWidget(
                    label: "Track Number",
                    value: metadata.trackNumber.toString(),
                    isStripedColor: true,
                  ),
                  MetadataItemWidget(
                    label: "Genre",
                    value: metadata.genre ?? "",
                    isStripedColor: false,
                  ),
                  MetadataItemWidget(
                    label: "Year",
                    value:
                        metadata.year == null ? "" : metadata.year.toString(),
                    isStripedColor: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
