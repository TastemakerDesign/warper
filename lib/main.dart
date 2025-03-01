import "package:audio_service/audio_service.dart";
import "package:flutter/material.dart";
import "package:flutter_zustand/flutter_zustand.dart";
import "package:warper/CustomAudioHandler.dart";
import "package:warper/MyApp.dart";
import "package:window_manager/window_manager.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  await windowManager.waitUntilReadyToShow();
  await windowManager.maximize();
  await AudioService.init(
    builder: () => MyAudioHandler(),
    config: AudioServiceConfig(),
  );
  runApp(
    StoreScope(
      child: MyApp(),
    ),
  );
}
