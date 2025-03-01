import "package:flutter/material.dart";
import "package:flutter_zustand/flutter_zustand.dart";
import "package:warper/CustomTheme.dart";
import "package:warper/functions/getAlbumName.dart";
import "package:warper/functions/getSongTitle.dart";
import "package:warper/stores/CurrentlyPlayingStore.dart";

class NowPlayingSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentlyPlayingStore = useCurrentlyPlayingStore();
    final fileSystemEntity = currentlyPlayingStore.select(
      context,
      (state) => state.fileSystemEntity,
    );
    String songDisplayString = fileSystemEntity == null
        ? "No Song Playing"
        : getSongTitle(fileSystemEntity);
    String albumDisplayString =
        fileSystemEntity == null ? "" : getAlbumName(fileSystemEntity);

    return Tooltip(
      message: "Go to Song [⌘ L]",
      waitDuration: Duration(seconds: 1),
      child: Material(
        color: CustomTheme.transparent,
        child: Center(
          child: InkWell(
            onTap: () async => await _handleTap(),
            hoverColor: CustomTheme.gray7.withOpacity(0.1),
            highlightColor: CustomTheme.gray7.withOpacity(0.2),
            splashColor: CustomTheme.gray7.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8.0),
            child: Container(
              padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    // For some reason, different song titles cause the height of
                    // the text to change, which causes layout shift.
                    height: 24.0,
                    child: Text(
                      songDisplayString,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: CustomTheme.white,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  Text(
                    albumDisplayString,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: CustomTheme.gray7,
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleTap() async {
    final currentlyPlayingStore = useCurrentlyPlayingStore();
    await currentlyPlayingStore.navigateToCurrentlyPlayingFolder();
  }
}
