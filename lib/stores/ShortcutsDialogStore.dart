import "package:flutter_zustand/flutter_zustand.dart";

class ShortcutsDialogStore extends Store<({bool isShortcutsDialogVisible})> {
  ShortcutsDialogStore()
      : super(
          (isShortcutsDialogVisible: false,),
        );

  void showDialog() {
    set(
      (isShortcutsDialogVisible: true),
    );
  }

  void hideDialog() {
    set(
      (isShortcutsDialogVisible: false),
    );
  }
}

ShortcutsDialogStore useShortcutsDialogStore() =>
    create(() => ShortcutsDialogStore());
