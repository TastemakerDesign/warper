import "dart:ui";

import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:warper/CustomTheme.dart";
import "package:warper/functions/convertFramesToDuration.dart";
import "package:warper/stores/MetadataDialogStore.dart";
import "package:warper/stores/SearchQueryStore.dart";
import "package:warper/stores/ShortcutsDialogStore.dart";

class BlurFilterWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () async => await _handleTap(),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            color: CustomTheme.transparent,
          ),
        ),
      ),
    ).animate().fadeIn(duration: convertFramesToDuration(3));
  }

  Future<void> _handleTap() async {
    final searchQueryStore = useSearchQueryStore();
    final shortcutsDialogStore = useShortcutsDialogStore();
    final metadataDialogStore = useMetadataDialogStore();
    searchQueryStore.hideSearchDialog();
    shortcutsDialogStore.hideDialog();
    metadataDialogStore.hideDialog();
  }
}
