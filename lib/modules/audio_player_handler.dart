import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerHandler {
  static AudioPlayerHandler? _instance;
  AudioPlayerHandler._();
  static AudioPlayerHandler get inst => _instance ??= AudioPlayerHandler._();

  // * AUDIO PLAYER * /
  AudioPlayer? player;
  Duration? duration; // Create a player
  double readSpeed = 1.0; // 1.0 -> 1.5 -> 2.0 -> 1.0

  void initialize() => player = AudioPlayer();

  Future<void> loadUrl(String url) async {
    duration = await player?.setUrl(url);
    // duration = await player?.setUrl("https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3");
  }

  Future<void> loadFromStream(Uint8List data) async {
    duration = await player?.setAudioSource(_MyCustomSource(data));
  }

  void dispose() async {
    await player?.seek(Duration.zero);
    await player?.stop();
    await player?.dispose();
    player = null;
  }

  void setSpeed() {
    readSpeed = switch (readSpeed) {
      1.0 => 1.5,
      1.5 => 2.0,
      2.0 => 1.0,
      _ => 1.0,
    };

    player?.setSpeed(readSpeed);
  }
}

class _MyCustomSource extends StreamAudioSource {
  final Uint8List bytes;
  _MyCustomSource(this.bytes);

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start ??= 0;
    end ??= bytes.length;
    return StreamAudioResponse(
      sourceLength: bytes.length,
      contentLength: end - start,
      offset: start,
      stream: Stream.value(bytes.sublist(start, end)),
      contentType: 'audio/pcm', // audio/L16 | audio/wav | audio/pcm
    );
  }
}
