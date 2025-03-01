import "dart:math";

import "package:flutter_media_metadata/flutter_media_metadata.dart";
import "package:flutter_zustand/flutter_zustand.dart";
import "package:warper/functions/filterSongsBySearchQuery.dart";
import "package:warper/stores/SongListStore.dart";

class SearchQueryStore extends Store<
    ({
      String searchQuery,
      bool isSearchDialogVisible,
      List<Metadata?>? searchResults,
      int? selectedSearchResultIndex,
    })> {
  static int maxVisibleItems = 10;

  SearchQueryStore()
      : super(
          (
            searchQuery: "",
            isSearchDialogVisible: false,
            searchResults: null,
            selectedSearchResultIndex: null,
          ),
        );

  void addCharacterToSearchQuery(String newCharacter) {
    final songListStore = useSongListStore();
    final songMetadata = songListStore.state.songMetadata;
    final newSearchQuery = state.searchQuery + newCharacter;
    final filteredSongs =
        filterSongsBySearchQuery(newSearchQuery, songMetadata);
    set(
      (
        searchQuery: newSearchQuery,
        searchResults: filteredSongs,
        selectedSearchResultIndex: null,
        isSearchDialogVisible: state.isSearchDialogVisible,
      ),
    );
  }

  void removeCharacterFromSearchQuery() {
    final songListStore = useSongListStore();
    final songMetadata = songListStore.state.songMetadata;
    final newSearchQuery = state.searchQuery.substring(
      0,
      max(state.searchQuery.length - 1, 0),
    );
    final filteredSongs = filterSongsBySearchQuery(
      newSearchQuery,
      songMetadata,
    );
    set(
      (
        searchQuery: newSearchQuery,
        searchResults: filteredSongs,
        selectedSearchResultIndex: null,
        isSearchDialogVisible: state.isSearchDialogVisible,
      ),
    );
  }

  void removeLastWordFromSearchQuery() {
    final songListStore = useSongListStore();
    final songMetadata = songListStore.state.songMetadata;
    String newSearchQuery = state.searchQuery;
    newSearchQuery = newSearchQuery.trimRight();
    List<String> segments = newSearchQuery.split(" ");
    segments.removeLast();
    newSearchQuery = segments.join(" ") + " ";
    if (newSearchQuery == " ") {
      newSearchQuery = "";
    }
    final filteredSongs = filterSongsBySearchQuery(
      newSearchQuery,
      songMetadata,
    );
    set(
      (
        searchQuery: newSearchQuery,
        searchResults: filteredSongs,
        selectedSearchResultIndex: null,
        isSearchDialogVisible: state.isSearchDialogVisible,
      ),
    );
  }

  void clearSearchQuery() {
    final songListStore = useSongListStore();
    final songMetadata = songListStore.state.songMetadata;
    final filteredSongs = filterSongsBySearchQuery("", songMetadata);
    set(
      (
        searchQuery: "",
        searchResults: filteredSongs,
        selectedSearchResultIndex: null,
        isSearchDialogVisible: state.isSearchDialogVisible,
      ),
    );
  }

  void showSearchDialog() {
    set(
      (
        isSearchDialogVisible: true,
        selectedSearchResultIndex: null,
        searchQuery: state.searchQuery,
        searchResults: state.searchResults,
      ),
    );
  }

  void hideSearchDialog() {
    set(
      (
        isSearchDialogVisible: false,
        searchQuery: "",
        searchResults: [],
        selectedSearchResultIndex: null,
      ),
    );
  }

  void highlightPreviousResult() {
    final searchResults = state.searchResults;
    if (searchResults == null) {
      return;
    }
    int? selectedSearchResultIndex = state.selectedSearchResultIndex;
    if (selectedSearchResultIndex == null ||
        selectedSearchResultIndex - 1 < 0) {
      selectedSearchResultIndex =
          min(SearchQueryStore.maxVisibleItems, searchResults.length) - 1;
    } else {
      selectedSearchResultIndex =
          (selectedSearchResultIndex - 1) % SearchQueryStore.maxVisibleItems;
    }
    set(
      (
        isSearchDialogVisible: state.isSearchDialogVisible,
        searchQuery: state.searchQuery,
        searchResults: state.searchResults,
        selectedSearchResultIndex: selectedSearchResultIndex,
      ),
    );
  }

  void highlightNextResult() {
    final searchResults = state.searchResults;
    if (searchResults == null) {
      return;
    }
    int? selectedSearchResultIndex = state.selectedSearchResultIndex;
    if (selectedSearchResultIndex == null ||
        (selectedSearchResultIndex + 1) >
            (min(SearchQueryStore.maxVisibleItems, searchResults.length) - 1)) {
      selectedSearchResultIndex = 0;
    } else {
      selectedSearchResultIndex =
          (selectedSearchResultIndex + 1) % SearchQueryStore.maxVisibleItems;
    }
    set(
      (
        isSearchDialogVisible: state.isSearchDialogVisible,
        searchQuery: state.searchQuery,
        searchResults: state.searchResults,
        selectedSearchResultIndex: selectedSearchResultIndex,
      ),
    );
  }
}

SearchQueryStore useSearchQueryStore() => create(() => SearchQueryStore());
