import "package:flutter/material.dart";
import "package:flutter_zustand/flutter_zustand.dart";
import "package:warper/CustomTheme.dart";
import "package:warper/stores/SearchQueryStore.dart";
import "package:warper/widgets/SearchDialog/SearchResultsList/SearchTile/SearchTile.dart";

class SearchResultsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final searchQueryStore = useSearchQueryStore();
    final filteredSongs = searchQueryStore.select(
          context,
          (state) => state.searchResults,
        ) ??
        [];

    if (filteredSongs.isEmpty) {
      return Center(
        child: Text(
          "No Songs Found",
          style: TextStyle(
            color: CustomTheme.gray7,
            fontSize: 16.0,
          ),
        ),
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final tileHeight = 64.0;
        final int maxVisibleItems =
            (constraints.maxHeight / tileHeight).floor();
        SearchQueryStore.maxVisibleItems = maxVisibleItems;
        return ListView.builder(
          itemCount: filteredSongs.length > maxVisibleItems
              ? maxVisibleItems
              : filteredSongs.length,
          itemBuilder: (context, index) {
            final isStripedColor = index % 2 == 0;
            return SearchTile(
              isStripedColor: isStripedColor,
              song: filteredSongs[index],
            );
          },
        );
      },
    );
  }
}
