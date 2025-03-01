import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:warper/CustomTheme.dart";
import "package:warper/functions/shortcuts/metadataKeyPressActions.dart";
import "package:warper/functions/shortcuts/normalKeyPressActions.dart";
import "package:warper/functions/shortcuts/searchKeyPressActions.dart";
import "package:warper/functions/shortcuts/shortcutKeyPressActions.dart";
import "package:warper/widgets/ShortcutsDialog/CloseDialogButton/CloseDialogButton.dart";
import "package:warper/widgets/ShortcutsDialog/ShortcutTile/ShortcutTile.dart";
import "package:warper/widgets/ShortcutsDialog/TitleText/TitleText.dart";

class ShortcutsDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(32.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: CustomTheme.black,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Keyboard Shortcuts",
                  style: TextStyle(
                    color: CustomTheme.white,
                    fontSize: 32.0,
                  ),
                ),
                CloseDialogButton(),
              ],
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              child: ListView(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 16.0),
                    child: TitleText(
                      text: "Main Page Keyboard Shortcuts",
                    ),
                  ),
                  ...normalKeyPressActions.mapIndexed((i, keyPressAction) {
                    return ShortcutTile(
                      isStripedColor: i % 2 == 0,
                      keyPressAction: keyPressAction,
                    );
                  }),
                  Container(
                    padding: EdgeInsets.fromLTRB(8.0, 64.0, 8.0, 16.0),
                    child: TitleText(
                      text: "Search Dialog Keyboard Shortcuts",
                    ),
                  ),
                  ...searchKeyPressActions.mapIndexed((i, keyPressAction) {
                    return ShortcutTile(
                      isStripedColor: i % 2 == 0,
                      keyPressAction: keyPressAction,
                    );
                  }),
                  Container(
                    padding: EdgeInsets.fromLTRB(8.0, 64.0, 8.0, 16.0),
                    child: TitleText(
                      text: "Shortcuts Dialog Keyboard Shortcuts",
                    ),
                  ),
                  ...shortcutKeyPressActions.mapIndexed((i, keyPressAction) {
                    return ShortcutTile(
                      isStripedColor: i % 2 == 0,
                      keyPressAction: keyPressAction,
                    );
                  }),
                  Container(
                    padding: EdgeInsets.fromLTRB(8.0, 64.0, 8.0, 16.0),
                    child: TitleText(
                      text: "Metadata Dialog Keyboard Shortcuts",
                    ),
                  ),
                  ...metadataKeyPressActions.mapIndexed((i, keyPressAction) {
                    return ShortcutTile(
                      isStripedColor: i % 2 == 0,
                      keyPressAction: keyPressAction,
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
