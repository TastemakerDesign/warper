import "package:flutter/material.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:flutter_zustand/flutter_zustand.dart";
import "package:warper/CustomTheme.dart";
import "package:warper/stores/WindowFocusStore.dart";
import "package:warper/widgets/CurrentlyPlayingWidget/CurrentlyPlayingSlider/CustomSlider/CustomSlider.dart";
import "package:warper/widgets/CurrentlyPlayingWidget/CurrentlyPlayingSlider/LeftText/LeftText.dart";
import "package:warper/widgets/CurrentlyPlayingWidget/CurrentlyPlayingSlider/RightText/RightText.dart";

class CurrentlyPlayingSlider extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final sliderValue = useState<double?>(null);
    final isHovered = useState(false);
    final windowFocusStore = useWindowFocusStore();
    final isWindowFocused = windowFocusStore.select(
      context,
      (state) => state.isWindowFocused,
    );

    return Focus(
      descendantsAreFocusable: false,
      canRequestFocus: false,
      child: MouseRegion(
        onEnter: (_) => isHovered.value = true,
        onExit: (_) => isHovered.value = false,
        child: Container(
          color:
              isWindowFocused == true ? CustomTheme.gray5 : CustomTheme.gray4,
          padding: EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                width: 36.0,
                child: LeftText(sliderValue: sliderValue),
              ),
              Expanded(
                child: CustomSlider(
                  sliderValue: sliderValue,
                  isHovered: isHovered,
                ),
              ),
              SizedBox(
                width: 36.0,
                child: RightText(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
