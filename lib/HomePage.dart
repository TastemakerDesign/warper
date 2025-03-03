import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_zustand/flutter_zustand.dart";
import "package:warper/CustomTheme.dart";
import "package:warper/functions/convertFramesToDuration.dart";
import "package:warper/stores/MetadataDialogStore.dart";
import "package:warper/stores/SearchQueryStore.dart";
import "package:warper/stores/ShortcutsDialogStore.dart";
import "package:warper/widgets/BlurFilterWidget/BlurFilterWidget.dart";
import "package:warper/widgets/CurrentlyPlayingWidget/CurrentlyPlayingSlider/CurrentlyPlayingSlider.dart";
import "package:warper/widgets/CurrentlyPlayingWidget/CurrentlyPlayingWidget.dart";
import "package:warper/widgets/MetadataDialog/MetadataDialog.dart";
import "package:warper/widgets/SearchDialog/SearchDialog.dart";
import "package:warper/widgets/ShortcutsDialog/ShortcutsDialog.dart";
import "package:warper/widgets/SongList/SongList.dart";

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final searchQueryStore = useSearchQueryStore();
    final shortcutsDialogStore = useShortcutsDialogStore();
    final metadataDialogStore = useMetadataDialogStore();
    final isSearchDialogVisible = searchQueryStore.select(
      context,
      (state) => state.isSearchDialogVisible,
    );
    final isShortcutsDialogVisible = shortcutsDialogStore.select(
      context,
      (state) => state.isShortcutsDialogVisible,
    );
    final isMetadataDialogVisible = metadataDialogStore.select(
      context,
      (state) => state.isMetadataDialogVisible,
    );
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: CustomTheme.gray2,
      body: Stack(
        children: [
          Stack(
            children: [
              Column(
                children: [
                  CurrentlyPlayingWidget(),
                  CurrentlyPlayingSlider(),
                  Expanded(
                    child: SongList(),
                  ),
                ],
              ),
              (isSearchDialogVisible ||
                      isShortcutsDialogVisible ||
                      isMetadataDialogVisible)
                  ? BlurFilterWidget()
                  : Container(),
            ],
          ),
          !isSearchDialogVisible
              ? Container()
              : Focus(
                  descendantsAreFocusable: false,
                  canRequestFocus: false,
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: screenWidth * 0.8,
                        maxHeight: screenHeight * 0.8,
                      ),
                      child: SearchDialog(),
                    ),
                  ),
                ).animate().fadeIn(duration: convertFramesToDuration(3)),
          !isShortcutsDialogVisible
              ? Container()
              : Focus(
                  descendantsAreFocusable: false,
                  canRequestFocus: false,
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: screenWidth * 0.6,
                        maxHeight: screenHeight * 0.8,
                      ),
                      child: ShortcutsDialog(),
                    ),
                  ),
                ).animate().fadeIn(duration: convertFramesToDuration(3)),
          !isMetadataDialogVisible
              ? Container()
              : Focus(
                  descendantsAreFocusable: false,
                  canRequestFocus: false,
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: screenWidth * 0.6,
                        maxHeight: screenHeight * 0.8,
                      ),
                      child: MetadataDialog(),
                    ),
                  ),
                ).animate().fadeIn(duration: convertFramesToDuration(3)),
        ],
      ),
    );
  }
}
