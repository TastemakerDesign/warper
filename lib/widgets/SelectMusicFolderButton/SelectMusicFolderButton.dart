import "package:flutter/material.dart";
import "package:flutter_zustand/flutter_zustand.dart";
import "package:warper/CustomTheme.dart";
import "package:warper/stores/CurrentFolderStore.dart";

class SelectMusicFolderButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentFolderStore = useCurentFolderStore();
    final isPicking = currentFolderStore.select(
      context,
      (state) => state.isPicking,
    );

    return Tooltip(
      message: "Open Folder [⌘ O]",
      waitDuration: Duration(seconds: 1),
      child: IconButton(
        onPressed: isPicking
            ? null
            : () async => await currentFolderStore.pickFolder(),
        color: CustomTheme.gray7,
        disabledColor: CustomTheme.gray7,
        iconSize: 32.0,
        icon: Icon(Icons.folder),
      ),
    );
  }
}
