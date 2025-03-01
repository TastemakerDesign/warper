import "package:flutter/material.dart";
import "package:warper/CustomTheme.dart";
import "package:warper/widgets/SongList/SongListEmptyWidget/OpenFolderButton/OpenFolderButton.dart";

class SongListEmptyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "No Music Folder Selected",
          style: TextStyle(
            color: CustomTheme.gray8,
            fontSize: 16.0,
          ),
        ),
        SizedBox(height: 12.0),
        OpenFolderButton(),
      ],
    );
  }
}
