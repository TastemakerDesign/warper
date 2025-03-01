import "package:flutter/material.dart";
import "package:warper/CustomTheme.dart";

class TitleText extends StatelessWidget {
  TitleText({
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: CustomTheme.gray8,
        fontSize: 24.0,
      ),
    );
  }
}
