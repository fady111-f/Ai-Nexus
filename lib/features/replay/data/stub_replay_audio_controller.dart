import 'package:mockmate/features/replay/domain/replay_audio_controller.dart';

/// No-op implementation of [ReplayAudioController] used when no recording
/// is available (e.g. demo sessions or sessions without audio).
///
/// All operations are safe no-ops. The UI should check [isLoaded] and
/// show "Recording unavailable" when it is `false`.
class StubReplayAudioController extends ReplayAudioController {
  @override
  Future<void> load(String uri) async {
    // No real audio to load.
  }

  @override
  Future<void> play() async {}

  @override
  Future<void> pause() async {}

  @override
  Future<void> seek(Duration position) async {}

  @override
  Future<void> skipForward({
    Duration amount = const Duration(seconds: 15),
  }) async {}

  @override
  Future<void> skipBackward({
    Duration amount = const Duration(seconds: 15),
  }) async {}

  @override
  Future<void> setSpeed(double speed) async {}

  @override
  Duration get currentPosition => Duration.zero;

  @override
  Duration get totalDuration => Duration.zero;

  @override
  bool get isPlaying => false;

  @override
  bool get isLoaded => false;

  @override
  bool get hasError => false;

  @override
  String? get errorMessage => null;
}
