import "package:flutter/material.dart";
import "package:warper/CustomTheme.dart";

class KeyboardKeyWidget extends StatelessWidget {
  final String text;
  final bool isSquare;

  KeyboardKeyWidget({
    required this.text,
    required this.isSquare,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: CustomTheme.gray3,
      ),
      alignment: Alignment.center,
      padding: isSquare ? null : EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
      height: 36.0,
      width: isSquare ? 36.0 : null,
      child: Text(
        text,
        style: CustomTheme.ibmPlexMonoFont.copyWith(
          color: CustomTheme.gray8,
          fontSize: 16.0,
        ),
      ),
    );
  }
}
