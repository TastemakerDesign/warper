import "package:flutter/material.dart";
import "package:warper/CustomTheme.dart";
import "package:warper/widgets/SearchDialog/ControlsRow/ControlsRow.dart";
import "package:warper/widgets/SearchDialog/SearchResultsList/SearchResultsList.dart";

class SearchDialog extends StatelessWidget {
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
          ControlsRow(),
          SizedBox(height: 16.0),
          Expanded(
            child: SearchResultsList(),
          ),
        ],
      ),
    );
  }
}
