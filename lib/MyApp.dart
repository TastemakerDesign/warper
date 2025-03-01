// ignore_for_file: no_widgets_without_same_name_parent_folder
import "dart:async";

import "package:flutter/gestures.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:warper/CustomTheme.dart";
import "package:warper/HomePage.dart";
import "package:warper/functions/navigateUpwardsAction.dart";
import "package:warper/functions/shortcuts/handleKeyPress.dart";
import "package:warper/stores/CurrentlyPlayingStore.dart";
import "package:warper/stores/WindowFocusStore.dart";
import "package:window_manager/window_manager.dart";

class MyApp extends HookWidget with WindowListener {
  @override
  Future<void> onWindowFocus() async {
    final windowFocusStore = useWindowFocusStore();
    await windowFocusStore.setIsWindowFocused(true);
  }

  @override
  Future<void> onWindowBlur() async {
    final windowFocusStore = useWindowFocusStore();
    await windowFocusStore.setIsWindowFocused(false);
  }

  @override
  void onWindowClose() {
    final currentlyPlayingStore = useCurrentlyPlayingStore();
    unawaited(currentlyPlayingStore.pauseSong());
  }

  Future<void> onPointerDown(PointerDownEvent event) async {
    if (event.buttons == kBackMouseButton) {
      await navigateUpwardsAction();
    }
  }

  @override
  Widget build(BuildContext context) {
    useEffect(
      () {
        windowManager.addListener(this);
        return () {
          windowManager.removeListener(this);
        };
      },
      [],
    );
    useEffect(
      () {
        bool _handleMacOSKeyPress(KeyEvent event) {
          // Return false to let other key events pass through.
          if (event is! KeyDownEvent) {
            return false;
          }
          // Return true to prevent the default quit behavior.
          if (event.logicalKey == LogicalKeyboardKey.keyQ &&
              HardwareKeyboard.instance.isMetaPressed) {
            return true;
          }
          return false;
        }

        ServicesBinding.instance.keyboard.addHandler(_handleMacOSKeyPress);
        return () {
          ServicesBinding.instance.keyboard.removeHandler(_handleMacOSKeyPress);
        };
      },
      [],
    );

    return MaterialApp(
      theme: ThemeData(
        textTheme: CustomTheme.interFont,
      ),
      title: "Warper",
      home: Listener(
        onPointerDown: onPointerDown,
        behavior: HitTestBehavior.opaque,
        child: KeyboardListener(
          focusNode: FocusNode()..requestFocus(),
          onKeyEvent: (KeyEvent event) async => await handleKeyPress(event),
          autofocus: true,
          child: HomePage(),
        ),
      ),
    );
  }
}
