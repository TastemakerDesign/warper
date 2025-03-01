import "package:file_picker/file_picker.dart";
import "package:flutter_zustand/flutter_zustand.dart";
import "package:warper/stores/SongListStore.dart";

class CurrentFolderStore
    extends Store<({String? currentFolderPath, bool isPicking})> {
  CurrentFolderStore()
      : super(
          (
            currentFolderPath: null,
            isPicking: false,
          ),
        );

  void setFolder(String? folderPath) {
    set(
      (
        currentFolderPath: folderPath,
        isPicking: state.isPicking,
      ),
    );
  }

  Future<void> pickFolder() async {
    final songListStore = useSongListStore();
    set(
      (
        currentFolderPath: state.currentFolderPath,
        isPicking: true,
      ),
    );
    try {
      String? folderPath = await FilePicker.platform.getDirectoryPath();
      if (folderPath == null) {
        return;
      }
      setFolder(folderPath);
      await songListStore.scanForFilesAndFolders(folderPath);
    } finally {
      set(
        (
          currentFolderPath: state.currentFolderPath,
          isPicking: false,
        ),
      );
    }
  }
}

CurrentFolderStore useCurentFolderStore() => create(() => CurrentFolderStore());
