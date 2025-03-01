import "package:flutter/material.dart";
import "package:warper/CustomTheme.dart";
import "package:warper/stores/SearchQueryStore.dart";

class CloseDialogButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async => await _handlePressed(),
      icon: Icon(
        Icons.close,
        color: CustomTheme.gray8,
      ),
    );
  }

  Future<void> _handlePressed() async {
    final searchQueryStore = useSearchQueryStore();
    searchQueryStore.hideSearchDialog();
  }
}
