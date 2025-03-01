import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:flutter_media_metadata/flutter_media_metadata.dart";
import "package:flutter_zustand/flutter_zustand.dart";
import "package:warper/CustomTheme.dart";
import "package:warper/functions/handleSearchResultSelectedAction.dart";
import "package:warper/stores/SearchQueryStore.dart";
import "package:warper/stores/WindowFocusStore.dart";
import "package:warper/widgets/SearchDialog/SearchResultsList/SearchTile/LeadingSegment/LeadingSegment.dart";
import "package:warper/widgets/SearchDialog/SearchResultsList/SearchTile/SubtitleSegment/SubtitleSegment.dart";
import "package:warper/widgets/SearchDialog/SearchResultsList/SearchTile/TitleSegment/TitleSegment.dart";
import "package:warper/widgets/SearchDialog/SearchResultsList/SearchTile/TrailingSegment/TrailingSegment.dart";

class SearchTile extends HookWidget {
  SearchTile({
    required this.isStripedColor,
    required this.song,
  });

  final bool isStripedColor;
  final Metadata? song;

  @override
  Widget build(BuildContext context) {
    final isHovered = useState<bool>(false);
    final searchQueryStore = useSearchQueryStore();
    final windowFocusStore = useWindowFocusStore();
    final (searchResults, selectedSearchResultIndex) = searchQueryStore.select(
      context,
      (state) => (state.searchResults, state.selectedSearchResultIndex),
    );
    final isWindowFocused = windowFocusStore.select(
      context,
      (state) => state.isWindowFocused,
    );

    bool isSelected = _determineIfSelected(
      searchResults,
      selectedSearchResultIndex,
    );

    return MouseRegion(
      onEnter: (e) {
        isHovered.value = true;
      },
      onExit: (e) {
        isHovered.value = false;
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: isSelected
              ? (isWindowFocused == false
                  ? CustomTheme.gray6
                  : CustomTheme.blue1)
              : isStripedColor
                  ? isHovered.value
                      ? CustomTheme.gray2
                      : CustomTheme.gray1
                  : isHovered.value
                      ? CustomTheme.gray2
                      : CustomTheme.black,
        ),
        child: ListTile(
          onTap: () async => await handleSearchResultSelectedAction(song),
          leading: LeadingSegment(song: song),
          title: TitleSegment(song: song),
          subtitle: SubtitleSegment(song: song, isSelected: isSelected),
          trailing: TrailingSegment(song: song, isSelected: isSelected),
        ),
      ),
    );
  }

  bool _determineIfSelected(
    List<Metadata?>? searchResults,
    int? selectedSearchResultIndex,
  ) {
    if (searchResults == null) {
      return false;
    }
    if (selectedSearchResultIndex == null) {
      return false;
    }
    final filePath = searchResults[selectedSearchResultIndex]?.filePath;
    if (filePath == null) {
      return false;
    }
    if (song?.filePath == null) {
      return false;
    }
    if (filePath != song?.filePath) {
      return false;
    }
    return true;
  }
}
