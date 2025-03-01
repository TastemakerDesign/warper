import "package:flutter/material.dart";
import "package:flutter_zustand/flutter_zustand.dart";
import "package:warper/CustomTheme.dart";
import "package:warper/functions/canNavigateUpwards.dart";
import "package:warper/functions/navigateUpwardsAction.dart";
import "package:warper/stores/CurrentFolderStore.dart";

class NavigateUpwardsButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentFolderStore = useCurentFolderStore();
    final musicPath = currentFolderStore.select(
      context,
      (state) => state.currentFolderPath,
    );

    return Tooltip(
      message: "Navigate Upward [⌘ Up]",
      waitDuration: Duration(seconds: 1),
      child: IconButton(
        onPressed: (musicPath != null && canNavigateUpwards(musicPath))
            ? () async => await handlePressed()
            : null,
        color: CustomTheme.gray7,
        disabledColor: CustomTheme.gray7,
        iconSize: 32.0,
        icon: Icon(
          Icons.chevron_left,
        ),
      ),
    );
  }

  Future<void> handlePressed() async {
    await navigateUpwardsAction();
  }
}
