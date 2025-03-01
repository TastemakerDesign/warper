import "dart:async";
import "dart:io";

import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:flutter_zustand/flutter_zustand.dart";
import "package:path/path.dart" as p;
import "package:warper/CustomTheme.dart";
import "package:warper/functions/findCoverImage.dart";
import "package:warper/functions/handleDoubleClickFolderAction.dart";
import "package:warper/stores/FileHighlightingStore.dart";
import "package:warper/stores/WindowFocusStore.dart";
import "package:warper/widgets/FolderTile/LeadingSegment/LeadingSegment.dart";

class FolderTile extends HookWidget {
  final bool isStripedColor;
  final FileSystemEntity fileSystemEntity;

  FolderTile({
    required this.isStripedColor,
    required this.fileSystemEntity,
  });

  final doubleTapThreshold = Duration(milliseconds: 300);
  final thumbnailSize = 40.0; // Ensure uniform image & icon size

  @override
  Widget build(BuildContext context) {
    final lastTapTime = useState<DateTime?>(null);
    final doubleTapTimer = useState<Timer?>(null);
    final isHovered = useState<bool>(false);
    final coverImagePath = useState<String?>(null);
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

    // Check for `cover.jpg` or other images in the folder
    useEffect(
      () {
        unawaited(
          findCoverImage(fileSystemEntity.path).then((path) {
            try {
              coverImagePath.value = path;
            } catch (_) {
              return null;
            }
          }),
        );
        return null;
      },
      [fileSystemEntity],
    );

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
            imagePath: coverImagePath.value,
            thumbnailSize: thumbnailSize,
          ),
          title: Container(
            padding: EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
            child: Text(
              p.basename(fileSystemEntity.path),
              style: TextStyle(
                color: isSelected ? CustomTheme.white : CustomTheme.gray8,
                fontSize: 14.0,
              ),
            ),
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
      doubleTapTimer.value?.cancel();
      lastTapTime.value = null;
      await _handleDoubleClick();
    } else {
      await _handleSingleClick();
      lastTapTime.value = now;
      doubleTapTimer.value = Timer(doubleTapThreshold, () {
        lastTapTime.value = null;
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
    final fileHighlightingStore = useFileHighlightingStore();
    await handleDoubleClickFolderAction(fileSystemEntity);
    await fileHighlightingStore.highlightEntryFromTeleport(
      fileSystemEntity,
      true,
    );
  }
}
