import "package:flutter_zustand/flutter_zustand.dart";
import "package:window_size/window_size.dart";

class WindowFocusStore extends Store<
    ({
      bool? isWindowFocused,
      int? numberOfScreens,
    })> {
  WindowFocusStore()
      : super(
          (
            isWindowFocused: null,
            numberOfScreens: null,
          ),
        );

  Future<void> setIsWindowFocused(bool? newIsWindowFocused) async {
    set(
      (
        isWindowFocused: newIsWindowFocused,
        numberOfScreens: (await getScreenList()).length
      ),
    );
  }
}

WindowFocusStore useWindowFocusStore() => create(() => WindowFocusStore());
