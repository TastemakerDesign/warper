import "package:flutter/material.dart";
import "package:warper/CustomTheme.dart";
import "package:warper/stores/ShortcutsDialogStore.dart";

class ShowShortcutsDialogButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: "Show Shortcuts [⌘ /]",
      waitDuration: Duration(seconds: 1),
      child: IconButton(
        onPressed: () async => await _handlePressed(),
        color: CustomTheme.gray7,
        disabledColor: CustomTheme.gray7,
        iconSize: 32.0,
        icon: Icon(Icons.keyboard_alt_outlined),
      ),
    );
  }

  Future<void> _handlePressed() async {
    final shortcutsDialogStore = useShortcutsDialogStore();
    shortcutsDialogStore.showDialog();
  }
}
