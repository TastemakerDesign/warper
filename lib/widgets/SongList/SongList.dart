import "dart:io";

import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_zustand/flutter_zustand.dart";
import "package:super_context_menu/super_context_menu.dart";
import "package:warper/stores/FileHighlightingStore.dart";
import "package:warper/stores/SongListStore.dart";
import "package:warper/widgets/FileTile/FileTile.dart";
import "package:warper/widgets/FolderTile/FolderTile.dart";
import "package:warper/widgets/SongList/SongListEmptyWidget/SongListEmptyWidget.dart";
import "package:warper/widgets/SongList/SongListMenu/SongListMenu.dart";

class SongList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final songListStore = useSongListStore();
    final (songList, songMetadata) = songListStore.select(
      context,
      (state) => (state.songList, state.songMetadata),
    );

    if (songList == null || songList.isEmpty) {
      return SongListEmptyWidget();
    }
    return ListView.builder(
      controller: FileHighlightingStore.scrollController,
      itemCount: songList.length,
      padding: EdgeInsets.all(24.0),
      physics: AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final fileSystemEntity = songList[index];
        final metadata = songMetadata?[fileSystemEntity.path];
        final isDirectory = fileSystemEntity is Directory;

        return ContextMenuWidget(
          menuProvider: (_) => buildSongListMenu(fileSystemEntity),
          child: Container(
            key: songListStore.getGlobalKeyForSong(fileSystemEntity.path),
            child: isDirectory
                ? FolderTile(
                    isStripedColor: index % 2 == 0,
                    fileSystemEntity: fileSystemEntity,
                  )
                : FileTile(
                    isStripedColor: index % 2 == 0,
                    fileSystemEntity: fileSystemEntity,
                    metadata: metadata,
                  ),
          ),
        );
      },
    )
        .animate(
          adapter: ValueNotifierAdapter(
            FileHighlightingStore.animationRestart,
          ),
          onPlay: (controller) => controller.repeat(),
        )
        .fadeIn(duration: Duration(milliseconds: 1000));
  }
}
