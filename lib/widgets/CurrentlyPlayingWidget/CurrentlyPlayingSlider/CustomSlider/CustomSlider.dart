import "dart:math";

import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:flutter_zustand/flutter_zustand.dart";
import "package:warper/CustomTheme.dart";
import "package:warper/stores/CurrentlyPlayingStore.dart";

class CustomSlider extends HookWidget {
  final ValueNotifier<double?> sliderValue;
  final ValueNotifier<bool> isHovered;

  CustomSlider({
    required this.sliderValue,
    required this.isHovered,
  });

  @override
  Widget build(BuildContext context) {
    final currentlyPlayingStore = useCurrentlyPlayingStore();
    final (position, duration, samplesWaveform) = currentlyPlayingStore.select(
      context,
      (state) => (state.position, state.duration, state.samplesWaveform),
    );
    double currentPosition =
        sliderValue.value ?? (position.inMilliseconds / 1000).toDouble();
    double maxValue = duration.inSeconds.toDouble();
    final animationController = useAnimationController(
      duration: Duration(milliseconds: 300),
    );
    useEffect(
      () {
        if (isHovered.value) {
          animationController.forward();
        } else {
          animationController.reverse();
        }
        return null;
      },
      [isHovered.value],
    );

    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return Container(
          padding: EdgeInsets.all(24.0),
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4.0,
              overlayShape: RoundSliderOverlayShape(
                overlayRadius: 8.0,
              ),
              thumbShape: RoundSliderThumbShape(
                enabledThumbRadius: 8.0 * animationController.value,
              ),
              trackShape: animationController.value > 0
                  ? _VolumeTrackShape(
                      opacity: animationController.value,
                      samplesWaveform: samplesWaveform ?? [],
                    )
                  : RoundedRectSliderTrackShape(),
            ),
            child: Slider(
              thumbColor: isHovered.value ? CustomTheme.white : null,
              value: min(currentPosition, maxValue),
              min: 0,
              max: maxValue == 0.0 ? 1 : maxValue,
              onChanged: (value) {
                sliderValue.value = value;
              },
              onChangeEnd: (value) async {
                await currentlyPlayingStore.seekTo(
                  Duration(seconds: value.toInt()),
                );
                sliderValue.value = null;
              },
              activeColor: CustomTheme.gray8,
              inactiveColor: CustomTheme.gray7,
            ),
          ),
        );
      },
    );
  }
}

class _VolumeTrackShape extends RoundedRectSliderTrackShape {
  final double opacity;
  final List<double> samplesWaveform;

  _VolumeTrackShape({
    required this.opacity,
    required this.samplesWaveform,
  });

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    Offset? secondaryOffset,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    bool isDiscrete = false,
    bool isEnabled = false,
    double additionalActiveTrackHeight = 0,
  }) {
    super.paint(
      context,
      offset,
      parentBox: parentBox,
      secondaryOffset: secondaryOffset,
      sliderTheme: sliderTheme,
      enableAnimation: enableAnimation,
      textDirection: textDirection,
      thumbCenter: thumbCenter,
      isDiscrete: isDiscrete,
      isEnabled: isEnabled,
      additionalActiveTrackHeight: additionalActiveTrackHeight,
    );

    final trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );

    final paint = Paint()
      ..color = CustomTheme.blue2.withOpacity(0.5 * opacity)
      ..strokeWidth = 1.0;

    final points = samplesWaveform
        .map((sample) => (sample * 15.0).clamp(0.0, 10.0))
        .toList();

    final canvas = context.canvas;
    final stepWidth = trackRect.width / points.length;

    for (var i = 0; i < points.length; i++) {
      final x = trackRect.left + (i * stepWidth);
      final height = trackRect.height * points[i] * opacity;
      canvas.drawLine(
        Offset(x, trackRect.center.dy - height / 2),
        Offset(x, trackRect.center.dy + height / 2),
        paint,
      );
    }
  }
}
