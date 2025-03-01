import "package:flutter/material.dart";
import "package:warper/widgets/SearchDialog/ControlsRow/CloseDialogButton/CloseDialogButton.dart";
import "package:warper/widgets/SearchDialog/ControlsRow/SearchBox/SearchBox.dart";

class ControlsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: SearchBox(),
        ),
        SizedBox(width: 12.0),
        CloseDialogButton(),
      ],
    );
  }
}
