import "package:flutter/material.dart";
import "package:flutter_zustand/flutter_zustand.dart";
import "package:warper/CustomTheme.dart";
import "package:warper/stores/CurrentFolderStore.dart";

class OpenFolderButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentFolderStore = useCurentFolderStore();
    final isPicking = currentFolderStore.select(
      context,
      (state) => state.isPicking,
    );

    return TextButton(
      onPressed:
          isPicking ? null : () async => await currentFolderStore.pickFolder(),
      style: TextButton.styleFrom(
        foregroundColor: CustomTheme.gray7,
        disabledForegroundColor: CustomTheme.gray7,
        textStyle: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.folder,
              color: CustomTheme.gray7,
            ),
            SizedBox(width: 8.0),
            Text("Open Folder"),
          ],
        ),
      ),
    );
  }
}
