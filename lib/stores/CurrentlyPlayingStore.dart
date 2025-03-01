// ignore_for_file: no_dart_files_with_more_than_200_lines_of_code
import "dart:async";
import "dart:io";

import "package:flutter_zustand/flutter_zustand.dart";
import "package:just_audio/just_audio.dart";
import "package:warper/functions/handleDoubleClickFolderAction.dart";
import "package:warper/stores/FileHighlightingStore.dart";
import "package:warper/stores/SongListStore.dart";
import "package:warper/volume_extractor.dart";

class CurrentlyPlayingStore extends Store<
    ({
      FileSystemEntity? fileSystemEntity,
      AudioPlayer? audioPlayer,
      bool isPlaying,
      Duration duration,
      Duration position,
      List<double>? samplesWaveform,
    })> {
  final AudioPlayer _player = AudioPlayer();

  AudioPlayer getPlayer() {
    return _player;
  }

  CurrentlyPlayingStore()
      : super(
          (
            fileSystemEntity: null,
            audioPlayer: null,
            isPlaying: false,
            duration: Duration.zero,
            position: Duration.zero,
            samplesWaveform: null,
          ),
        );

  Future<void> changeSong(FileSystemEntity fileSystemEntity) async {
    String filePath = fileSystemEntity.path;
    await _player.setFilePath(filePath);
    set(
      (
        audioPlayer: state.audioPlayer,
        duration: state.duration,
        isPlaying: state.isPlaying,
        position: state.position,
        fileSystemEntity: fileSystemEntity,
        samplesWaveform: null,
      ),
    );
  }

  Future<void> playSong(FileSystemEntity fileSystemEntity) async {
    String filePath = fileSystemEntity.path;
    await _player.setFilePath(filePath);
    unawaited(
      VolumeExtractor.extractVolumeData(filePath).then((waveformSamples) {
        set(
          (
            audioPlayer: state.audioPlayer,
            duration: state.duration,
            position: state.position,
            fileSystemEntity: state.fileSystemEntity,
            isPlaying: state.isPlaying,
            samplesWaveform: waveformSamples,
          ),
        );
      }),
    );
    unawaited(_player.play());
    set(
      (
        audioPlayer: state.audioPlayer,
        duration: state.duration,
        position: state.position,
        fileSystemEntity: fileSystemEntity,
        isPlaying: true,
        samplesWaveform: null,
      ),
    );
  }

  Future<void> pauseSong() async {
    await _player.pause();
    set(
      (
        audioPlayer: state.audioPlayer,
        duration: state.duration,
        fileSystemEntity: state.fileSystemEntity,
        position: state.position,
        isPlaying: false,
        samplesWaveform: state.samplesWaveform,
      ),
    );
  }

  Future<void> stopSong() async {
    await _player.stop();
    set(
      (
        audioPlayer: state.audioPlayer,
        duration: state.duration,
        fileSystemEntity: state.fileSystemEntity,
        position: state.position,
        isPlaying: false,
        samplesWaveform: state.samplesWaveform,
      ),
    );
  }

  Future<void> resumeSong() async {
    unawaited(_player.play());
    set(
      (
        audioPlayer: state.audioPlayer,
        duration: state.duration,
        fileSystemEntity: state.fileSystemEntity,
        position: state.position,
        isPlaying: true,
        samplesWaveform: state.samplesWaveform,
      ),
    );
  }

  Future<void> seekTo(Duration position) async {
    await _player.seek(position);
    set(
      (
        audioPlayer: state.audioPlayer,
        duration: state.duration,
        fileSystemEntity: state.fileSystemEntity,
        isPlaying: state.isPlaying,
        position: position,
        samplesWaveform: state.samplesWaveform,
      ),
    );
  }

  Future<void> playPauseButtonPressed() async {
    if (state.fileSystemEntity == null) {
      return;
    }
    if (state.isPlaying) {
      await pauseSong();
    } else {
      await resumeSong();
    }
  }

  Future<void> updateDuration(Duration duration) async {
    set(
      (
        audioPlayer: state.audioPlayer,
        fileSystemEntity: state.fileSystemEntity,
        isPlaying: state.isPlaying,
        position: state.position,
        duration: duration,
        samplesWaveform: state.samplesWaveform,
      ),
    );
  }

  Future<void> updatePosition(Duration position) async {
    set(
      (
        audioPlayer: state.audioPlayer,
        duration: state.duration,
        fileSystemEntity: state.fileSystemEntity,
        isPlaying: state.isPlaying,
        position: position,
        samplesWaveform: state.samplesWaveform,
      ),
    );
  }

  Future<void> handleSongEnded() async {
    final songListStore = useSongListStore();
    final songList = songListStore.state.songList;
    if (songList == null || songList.isEmpty) {
      return;
    }
    FileSystemEntity? currentSong = state.fileSystemEntity;
    if (currentSong == null) {
      return;
    }
    int currentIndex =
        songList.indexWhere((song) => song.path == currentSong.path);
    if (currentIndex == songList.length - 1) {
      FileSystemEntity firstSong = songList[0];
      await stopSong();
      await changeSong(firstSong);
    } else {
      await playNextSong();
    }
  }

  Future<void> playNextSong() async {
    final songListStore = useSongListStore();
    final currentSong = state.fileSystemEntity;
    if (currentSong == null) {
      return;
    }
    List<FileSystemEntity> songList =
        await songListStore.getSongList(currentSong.parent.path);
    int currentIndex =
        songList.indexWhere((song) => song.path == currentSong.path);
    int nextIndex = (currentIndex + 1) % songList.length;
    FileSystemEntity nextSong = songList[nextIndex];
    if (state.isPlaying) {
      await playSong(nextSong);
    } else {
      await changeSong(nextSong);
    }
    if (nextIndex == 0) {
      await stopSong();
      await seekTo(Duration.zero);
    }
  }

  Future<void> playPreviousSong() async {
    final songListStore = useSongListStore();
    final currentSong = state.fileSystemEntity;
    if (currentSong == null) {
      return;
    }
    List<FileSystemEntity> songList =
        await songListStore.getSongList(currentSong.parent.path);
    int currentIndex =
        songList.indexWhere((song) => song.path == currentSong.path);
    int nextIndex = (currentIndex - 1) % songList.length;
    FileSystemEntity previousSong = songList[nextIndex];
    if (state.isPlaying) {
      await playSong(previousSong);
    } else {
      await changeSong(previousSong);
    }
  }

  Future<void> navigateToCurrentlyPlayingFolder() async {
    final currentSong = state.fileSystemEntity;
    if (currentSong == null) {
      return;
    }
    final fileHighlightingStore = useFileHighlightingStore();
    await handleDoubleClickFolderAction(
      currentSong.parent,
    );
    await fileHighlightingStore.highlightEntryFromTeleport(
      currentSong,
      false,
    );
  }
}

CurrentlyPlayingStore useCurrentlyPlayingStore() =>
    create(() => CurrentlyPlayingStore());
