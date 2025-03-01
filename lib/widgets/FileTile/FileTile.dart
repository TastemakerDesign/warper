import "dart:async";
import "dart:io";

import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:flutter_media_metadata/flutter_media_metadata.dart";
import "package:flutter_zustand/flutter_zustand.dart";
import "package:warper/CustomTheme.dart";
import "package:warper/functions/handleDoubleClickFileAction.dart";
import "package:warper/stores/FileHighlightingStore.dart";
import "package:warper/stores/WindowFocusStore.dart";
import "package:warper/widgets/FileTile/LeadingSegment/LeadingSegment.dart";
import "package:warper/widgets/FileTile/TitleSegment/TitleSegment.dart";
import "package:warper/widgets/FileTile/TrailingSegment/TrailingSegment.dart";

class FileTile extends HookWidget {
  final bool isStripedColor;
  final FileSystemEntity fileSystemEntity;
  final Metadata? metadata;

  FileTile({
    required this.isStripedColor,
    required this.fileSystemEntity,
    required this.metadata,
  });

  final doubleTapThreshold = Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context) {
    final lastTapTime = useState<DateTime?>(null);
    final doubleTapTimer = useState<Timer?>(null);
    final isHovered = useState<bool>(false);
    final fileHighlightingStore = useFileHighlightingStore();
    final windowFocusStore = useWindowFocusStore();
    final currentlySelected = fileHighlightingStore.select(
      context,
      (state) => state.currentlySelected,
    );
    final isWindowFocused = windowFocusStore.select(
      context,
      (state) => state.isWindowFocused,
    );
    final isSelected = currentlySelected?.path == fileSystemEntity.path;

    return MouseRegion(
      onEnter: (e) {
        isHovered.value = true;
      },
      onExit: (e) {
        isHovered.value = false;
      },
      child: GestureDetector(
        onTap: () async => await _handleTap(lastTapTime, doubleTapTimer),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          contentPadding: EdgeInsets.fromLTRB(18.0, 6.0, 18.0, 6.0),
          tileColor: isSelected
              ? (isWindowFocused == false
                  ? CustomTheme.gray6
                  : CustomTheme.blue1)
              : isHovered.value
                  ? CustomTheme.gray4
                  : isStripedColor
                      ? CustomTheme.gray3
                      : null,
          leading: LeadingSegment(
            fileSystemEntity: fileSystemEntity,
            isHovered: isHovered,
            isSelected: isSelected,
            metadata: metadata,
          ),
          title: TitleSegment(
            isSelected: isSelected,
            fileSystemEntity: fileSystemEntity,
            metadata: metadata,
          ),
          trailing: TrailingSegment(
            isSelected: isSelected,
            metadata: metadata,
          ),
        ),
      ),
    );
  }

  Future<void> _handleTap(
    ValueNotifier<DateTime?> lastTapTime,
    ValueNotifier<Timer?> doubleTapTimer,
  ) async {
    final now = DateTime.now();
    if (lastTapTime.value != null &&
        now.difference(lastTapTime.value!) < doubleTapThreshold) {
      // Cancel the pending single click if any
      doubleTapTimer.value?.cancel();
      lastTapTime.value = null;
      await _handleDoubleClick();
    } else {
      await _handleSingleClick();
      // Set up a timer in case a double-tap happens
      lastTapTime.value = now;
      doubleTapTimer.value = Timer(doubleTapThreshold, () {
        // Reset after threshold to avoid false double taps
        try {
          lastTapTime.value = null;
        } catch (_) {
          return;
        }
      });
    }
  }

  Future<void> _handleSingleClick() async {
    final fileHighlightingStore = useFileHighlightingStore();
    await fileHighlightingStore.highlightClickedEntry(
      fileSystemEntity,
    );
  }

  Future<void> _handleDoubleClick() async {
    await handleDoubleClickFileAction(fileSystemEntity);
  }
}
