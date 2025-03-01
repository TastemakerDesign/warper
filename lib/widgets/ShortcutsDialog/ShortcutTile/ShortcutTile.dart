import "package:flutter/material.dart";
import "package:warper/CustomTheme.dart";
import "package:warper/functions/shortcuts/ActionType.dart";
import "package:warper/widgets/ShortcutsDialog/ShortcutTile/TrailingSegment/TrailingSegment.dart";

class ShortcutTile extends StatelessWidget {
  ShortcutTile({
    required this.isStripedColor,
    required this.keyPressAction,
  });

  final bool isStripedColor;
  final ActionType keyPressAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: isStripedColor ? CustomTheme.gray1 : CustomTheme.black,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            keyPressAction.name,
            style: TextStyle(
              color: CustomTheme.gray8,
              fontSize: 16.0,
            ),
          ),
          TrailingSegment(
            shortcuts: keyPressAction.shortcuts,
          ),
        ],
      ),
    );
  }
}
