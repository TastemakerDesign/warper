import "package:flutter/material.dart";
import "package:warper/CustomTheme.dart";

class MetadataItemWidget extends StatelessWidget {
  final String label;
  final String value;
  final bool isStripedColor;

  MetadataItemWidget({
    required this.label,
    required this.value,
    required this.isStripedColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: isStripedColor ? CustomTheme.gray1 : CustomTheme.black,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: CustomTheme.gray8,
              fontSize: 16.0,
            ),
          ),
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 400.0,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  value,
                  style: TextStyle(
                    color: CustomTheme.gray8,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
