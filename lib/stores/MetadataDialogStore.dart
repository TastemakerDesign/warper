import "package:flutter_zustand/flutter_zustand.dart";

class MetadataDialogStore extends Store<
    ({
      bool isMetadataDialogVisible,
      String? filePath,
    })> {
  MetadataDialogStore()
      : super(
          (
            isMetadataDialogVisible: false,
            filePath: null,
          ),
        );

  void showDialog(String newFilePath) {
    set(
      (
        isMetadataDialogVisible: true,
        filePath: newFilePath,
      ),
    );
  }

  void hideDialog() {
    set(
      (
        isMetadataDialogVisible: false,
        filePath: null,
      ),
    );
  }
}

MetadataDialogStore useMetadataDialogStore() =>
    create(() => MetadataDialogStore());
