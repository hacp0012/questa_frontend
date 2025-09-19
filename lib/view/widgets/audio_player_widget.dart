import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:just_audio/just_audio.dart';
import 'package:questa/configs/c_consts.dart';
import 'package:questa/modules/audio_player_handler.dart';
import 'package:questa/modules/extensions_utils_packs.dart';
import 'package:questa/view/widgets/c_toast.dart';
import 'package:run_it/run_it.dart';
import 'package:ui_value/ui_value.dart';

class AudioPlayerWidget extends StatefulWidget {
  const AudioPlayerWidget({super.key});
  // "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3"

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> with UiValueMixin {
  var player = AudioPlayerHandler.inst.player;
  Map? initialDuration;

  late var isDasabled = uiValue(false);
  late var isPlaying = uiValue(false);
  late var bufferDuration = uiValue<Duration?>(null);
  late var processState = uiValue<ProcessingState>(ProcessingState.idle);
  late var errorMessage = uiValue<String?>(null);

  // VIEW ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
  @override
  void initState() {
    super.initState();

    player?.bufferedPositionStream.listen((duration) => bufferDuration.value = duration);
    player?.playerStateStream.listen((state) {
      isPlaying.value = state.playing;
      processState.value = state.processingState;
      isDasabled.value = state.processingState == ProcessingState.loading;
      if (state.processingState == ProcessingState.completed) _stop();
    });
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      color: CConsts.LIGHT_COLOR,
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          "Enseignement audio de l'enseignement".t.muted.bold,
          4.5.gap,
          StreamBuilder(
            stream: player?.positionStream,
            builder: (context, duration) {
              Duration progressDuration = Duration();
              if (duration.hasData) progressDuration = duration.data!;
              return ProgressBar(
                progress: progressDuration,
                buffered: bufferDuration.value ?? Duration(),
                total: player?.duration ?? Duration(),
                thumbRadius: 6.6,
                timeLabelLocation: TimeLabelLocation.sides,
                onSeek: (position) => _setPosition(position),
              );
            },
          ),
          9.gap,
          Row(
            children: [
              // LOADING PLAY BUTTON.
              if (processState.value == ProcessingState.loading)
                IconButton(onPressed: null, icon: CircularProgressIndicator().sized(all: 18))
              else
                // PLAY - PAUSE BUTTON.
                Visibility(
                  visible: isPlaying.value,
                  replacement: IconButton(
                    onPressed: isDasabled.value ? null : () => _play(),
                    icon: Icon(IconsaxPlusLinear.play),
                  ),
                  child: IconButton(onPressed: isDasabled.value ? null : _pause, icon: Icon(IconsaxPlusLinear.pause)),
                ).animate().fadeIn(),
              9.gap,
              // STOP
              IconButton(onPressed: isDasabled.value ? null : _stop, icon: Icon(IconsaxPlusBold.stop)),
              const Spacer(),
              StreamBuilder(
                stream: player?.positionStream,
                builder: (context, duration) {
                  return IconButton(
                    onPressed: isDasabled.value || duration.data.isNull ? null : () => _stepedRewind(duration.data!),
                    icon: Icon(IconsaxPlusLinear.previous),
                  );
                },
              ),
              9.gap,
              TextButton(onPressed: isDasabled.value ? null : _setSpeed, child: "X${AudioPlayerHandler.inst.readSpeed}".t),
            ],
          ),

          // ERROR.
          StreamBuilder(
            stream: player?.errorStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                CToast(context, 6.seconds).error((snapshot.data?.message ?? "Erreur de lecture").t);
                return "Impossible d'atteindre l'audio".t.color(context.theme.colorScheme.error).center;
              } else {
                return Container();
              }
            },
          ),
        ],
      ).withPadding(all: 9),
    );
  }

  @override
  void Function(void Function() p1) get uiSetState => setState;
  // METHODS =================================================================================================================
  void _play() async {
    // print(ProcessingState.loading.name);
    // print(isDasabled.value);
    // print(isPlaying.value);
    // print(processState.value.name);
    if (!isDasabled.value && processState.value != ProcessingState.loading && !isPlaying.value) {
      await player?.play();
    }
    // await player?.play();
  }

  void _pause() async {
    if (!isDasabled.value && isPlaying.value) {
      await player?.pause();
    }
  }

  void _stop() async {
    if (!isDasabled.value) {
      await player?.stop();
      await player?.seek(Duration.zero);
    }
  }

  void _setSpeed() {
    if (!isDasabled.value && isPlaying.value) {
      AudioPlayerHandler.inst.setSpeed();
      uiUpdate();
    }
  }

  void _setPosition(Duration duration) async {
    if (!isDasabled.value && processState.value != ProcessingState.loading && isPlaying.value) {
      await player?.seek(duration);
    }
  }

  void _stepedRewind(Duration currentPosituin) {
    int stepInSeconds = 5;

    Duration newPosition = currentPosituin;
    if (currentPosituin.inSeconds < stepInSeconds) {
      newPosition = Duration.zero;
    } else {
      newPosition = (currentPosituin.inSeconds - stepInSeconds).seconds;
    }

    _setPosition(newPosition);
  }
}
