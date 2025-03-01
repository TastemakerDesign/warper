import "dart:async";

import "package:audio_service/audio_service.dart";
import "package:just_audio/just_audio.dart";
import "package:rxdart/rxdart.dart";
import "package:warper/functions/findCoverImage.dart";
import "package:warper/functions/getAlbumName.dart";
import "package:warper/functions/getSongTitle.dart";
import "package:warper/stores/CurrentlyPlayingStore.dart";
import "package:warper/stores/WindowFocusStore.dart";

class MyAudioHandler extends BaseAudioHandler {
  MyAudioHandler() {
    final currentlyPlayingStore = useCurrentlyPlayingStore();
    currentlyPlayingStore.getPlayer().playerStateStream.listen((state) {
      playbackState.add(
        PlaybackState(
          controls: state.playing
              ? [
                  MediaControl.pause,
                  MediaControl.stop,
                  MediaControl.skipToNext,
                  MediaControl.skipToPrevious,
                ]
              : [
                  MediaControl.play,
                  MediaControl.stop,
                ],
          processingState: AudioProcessingState.ready,
          playing: state.playing,
        ),
      );
      if (state.processingState == ProcessingState.completed) {
        unawaited(currentlyPlayingStore.handleSongEnded());
      }
    });

    final windowFocusStore = useWindowFocusStore();
    currentlyPlayingStore
        .getPlayer()
        .positionStream
        .where((_) => !(windowFocusStore.state.isWindowFocused ?? false))
        // Throttle when the window isn't focused to save on CPU.
        .throttleTime(
          Duration(
            // Throttle more aggressively if the user only has one monitor.
            // Most likely the window isn't visible at all in this case.
            seconds: (windowFocusStore.state.numberOfScreens ?? 1) == 1 ? 5 : 1,
          ),
        )
        .mergeWith([
      currentlyPlayingStore
          .getPlayer()
          .positionStream
          .where((_) => windowFocusStore.state.isWindowFocused ?? false),
    ]).listen((position) {
      playbackState.add(playbackState.value.copyWith(updatePosition: position));
      unawaited(currentlyPlayingStore.updatePosition(position));
    });

    currentlyPlayingStore.getPlayer().durationStream.listen((duration) {
      Future.delayed(Duration.zero, () async {
        final fileSystemEntity = currentlyPlayingStore.state.fileSystemEntity;
        String songDisplayString = fileSystemEntity == null
            ? "No Song Playing"
            : getSongTitle(fileSystemEntity);
        String albumDisplayString =
            fileSystemEntity == null ? "" : getAlbumName(fileSystemEntity);
        Uri? coverImageUri = fileSystemEntity == null
            ? null
            : Uri(
                scheme: "file",
                path: (await findCoverImage(fileSystemEntity.parent.path)),
              );
        mediaItem.add(
          MediaItem(
            id: songDisplayString,
            title: songDisplayString,
            album: albumDisplayString,
            duration: duration,
            artUri: coverImageUri,
          ),
        );
        if (duration == null) {
          return;
        }
        unawaited(currentlyPlayingStore.updateDuration(duration));
      });
    });
  }

  @override
  Future<void> play() async {
    final currentlyPlayingStore = useCurrentlyPlayingStore();
    await currentlyPlayingStore.resumeSong();
  }

  @override
  Future<void> pause() async {
    final currentlyPlayingStore = useCurrentlyPlayingStore();
    await currentlyPlayingStore.pauseSong();
  }

  @override
  Future<void> stop() async {
    final currentlyPlayingStore = useCurrentlyPlayingStore();
    await currentlyPlayingStore.stopSong();
  }

  @override
  Future<void> seek(Duration position) async {
    final currentlyPlayingStore = useCurrentlyPlayingStore();
    await currentlyPlayingStore.seekTo(position);
  }

  @override
  Future<void> skipToNext() async {
    final currentlyPlayingStore = useCurrentlyPlayingStore();
    await currentlyPlayingStore.playNextSong();
  }

  @override
  Future<void> skipToPrevious() async {
    final currentlyPlayingStore = useCurrentlyPlayingStore();
    await currentlyPlayingStore.playPreviousSong();
  }
}
