import "package:flutter/material.dart";
import "package:flutter_zustand/flutter_zustand.dart";
import "package:warper/CustomTheme.dart";
import "package:warper/stores/WindowFocusStore.dart";
import "package:warper/widgets/CurrentlyPlayingWidget/NextSongButton/NextSongButton.dart";
import "package:warper/widgets/CurrentlyPlayingWidget/NowPlayingSection/NowPlayingSection.dart";
import "package:warper/widgets/CurrentlyPlayingWidget/PlayPauseButton/PlayPauseButton.dart";
import "package:warper/widgets/CurrentlyPlayingWidget/PreviousSongButton/PreviousSongButton.dart";
import "package:warper/widgets/NavigateUpwardsButton/NavigateUpwardsButton.dart";
import "package:warper/widgets/SelectMusicFolderButton/SelectMusicFolderButton.dart";
import "package:warper/widgets/ShowShortcutsDialogButton/ShowShortcutsDialogButton.dart";

class CurrentlyPlayingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final windowFocusStore = useWindowFocusStore();
    final isWindowFocused = windowFocusStore.select(
      context,
      (state) => state.isWindowFocused,
    );

    return Focus(
      descendantsAreFocusable: false,
      canRequestFocus: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
        decoration: BoxDecoration(
          color:
              isWindowFocused == true ? CustomTheme.gray5 : CustomTheme.gray4,
        ),
        child: Row(
          children: [
            Row(
              children: [
                NavigateUpwardsButton(),
                SizedBox(width: 48.0),
              ],
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PreviousSongButton(),
                        PlayPauseButton(),
                        NextSongButton(),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: NowPlayingSection(),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                ShowShortcutsDialogButton(),
                SelectMusicFolderButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
