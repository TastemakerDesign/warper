import "package:flutter/material.dart";
import "package:flutter_zustand/flutter_zustand.dart";
import "package:warper/CustomTheme.dart";
import "package:warper/stores/CurrentFolderStore.dart";

class SongListNullWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentFolderStore = useCurentFolderStore();
    final isPicking = currentFolderStore.select(
      context,
      (state) => state.isPicking,
    );

    return Material(
      color: CustomTheme.transparent,
      child: Center(
        child: InkWell(
          onTap: isPicking
              ? null
              : () async => await currentFolderStore.pickFolder(),
          hoverColor: CustomTheme.gray7.withOpacity(0.1),
          highlightColor: CustomTheme.gray7.withOpacity(0.2),
          splashColor: CustomTheme.gray7.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8.0),
          child: Container(
            padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.folder,
                  size: 96.0,
                  color: CustomTheme.gray8,
                ),
                SizedBox(height: 12.0),
                Text(
                  "Select Music Folder",
                  style: TextStyle(
                    color: CustomTheme.gray8,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
