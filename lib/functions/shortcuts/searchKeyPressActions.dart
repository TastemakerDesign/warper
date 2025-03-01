import "package:flutter/services.dart";
import "package:warper/functions/handleSearchResultSelectedAction.dart";
import "package:warper/functions/shortcuts/ActionType.dart";
import "package:warper/stores/SearchQueryStore.dart";

final List<ActionType> searchKeyPressActions = [
  (
    name: "Highlight Next Result",
    shortcuts: [
      (LogicalKeyboardKey.arrowDown, false, false, false),
      (LogicalKeyboardKey.tab, false, false, false),
    ],
    action: () {
      final searchQueryStore = useSearchQueryStore();
      searchQueryStore.highlightNextResult();
    },
  ),
  (
    name: "Highlight Previous Result",
    shortcuts: [
      (LogicalKeyboardKey.arrowUp, false, false, false),
      (LogicalKeyboardKey.tab, false, true, false),
    ],
    action: () {
      final searchQueryStore = useSearchQueryStore();
      searchQueryStore.highlightPreviousResult();
    },
  ),
  (
    name: "Play Highlighted Song",
    shortcuts: [
      (LogicalKeyboardKey.enter, false, false, false),
    ],
    action: () async {
      final searchQueryStore = useSearchQueryStore();
      final index = searchQueryStore.state.selectedSearchResultIndex ?? 0;
      if ((searchQueryStore.state.searchResults ?? []).isEmpty) {
        return;
      }
      await handleSearchResultSelectedAction(
        searchQueryStore.state.searchResults?[index],
      );
    },
  ),
  (
    name: "Delete Last Character",
    shortcuts: [
      (LogicalKeyboardKey.backspace, false, false, false),
    ],
    action: () {
      final searchQueryStore = useSearchQueryStore();
      searchQueryStore.removeCharacterFromSearchQuery();
    },
  ),
  (
    name: "Delete Last Word",
    shortcuts: [
      (LogicalKeyboardKey.backspace, false, false, true),
    ],
    action: () {
      final searchQueryStore = useSearchQueryStore();
      searchQueryStore.removeLastWordFromSearchQuery();
    },
  ),
  (
    name: "Delete Search Query",
    shortcuts: [
      (LogicalKeyboardKey.backspace, true, false, false),
    ],
    action: () {
      final searchQueryStore = useSearchQueryStore();
      searchQueryStore.clearSearchQuery();
    },
  ),
  (
    name: "Close Search Dialog",
    shortcuts: [
      (LogicalKeyboardKey.escape, false, false, false),
    ],
    action: () {
      final searchQueryStore = useSearchQueryStore();
      searchQueryStore.hideSearchDialog();
    },
  ),
];
