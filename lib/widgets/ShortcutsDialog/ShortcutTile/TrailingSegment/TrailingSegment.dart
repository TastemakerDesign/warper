import "package:flutter/material.dart";
import "package:warper/CustomTheme.dart";
import "package:warper/functions/shortcuts/ShortcutType.dart";
import "package:warper/widgets/ShortcutsDialog/ShortcutTile/TrailingSegment/KeyboardKeyWidget/KeyboardKeyWidget.dart";

class TrailingSegment extends StatelessWidget {
  final List<ShortcutType> shortcuts;

  TrailingSegment({
    required this.shortcuts,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: shortcuts.asMap().entries.map((entry) {
        int index = entry.key;
        ShortcutType shortcut = entry.value;

        List<Widget> keys = [
          // Command Symbol
          if (shortcut.$2) KeyboardKeyWidget(text: "⌘", isSquare: true),
          // Shift Symbol
          if (shortcut.$3) KeyboardKeyWidget(text: "⇧", isSquare: true),
          // Option Symbol
          if (shortcut.$4) KeyboardKeyWidget(text: "⌥", isSquare: true),
          KeyboardKeyWidget(
            text: shortcut.$1.keyLabel == " " ? "Space" : shortcut.$1.keyLabel,
            isSquare: false,
          ),
        ];

        return Row(
          children: [
            Row(children: keys),
            if (index != shortcuts.length - 1)
              Text(
                " / ",
                style: CustomTheme.ibmPlexMonoFont.copyWith(
                  color: CustomTheme.gray7,
                  fontSize: 16.0,
                ),
              ),
          ],
        );
      }).toList(),
    );
  }
}
