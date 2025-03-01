import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_zustand/flutter_zustand.dart";
import "package:warper/CustomTheme.dart";
import "package:warper/stores/SearchQueryStore.dart";

class SearchBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final searchQueryStore = useSearchQueryStore();
    final searchQuery = searchQueryStore.select(
      context,
      (state) => state.searchQuery,
    );

    return Container(
      padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
      decoration: BoxDecoration(
        color: CustomTheme.gray2,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Icon(
            Icons.search,
            color: CustomTheme.gray8,
          ),
          SizedBox(width: 12.0),
          Text(
            searchQuery.isEmpty ? "Start typing to search..." : searchQuery,
            style: CustomTheme.ibmPlexMonoFont.copyWith(
              color:
                  searchQuery.isEmpty ? CustomTheme.gray7 : CustomTheme.gray8,
              fontSize: 16.0,
            ),
          ),
          SizedBox(width: 2.0),
          searchQuery.isEmpty
              ? Container()
              : Container(
                  color: CustomTheme.gray8,
                  height: 24.0,
                  width: 2.0,
                )
                  .animate(onPlay: (controller) => controller.repeat())
                  .fadeOut(duration: 1000.ms, curve: Curves.easeIn)
                  .fadeIn(duration: 1000.ms, curve: Curves.easeOut),
        ],
      ),
    );
  }
}
