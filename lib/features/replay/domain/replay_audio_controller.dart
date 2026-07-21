import 'package:flutter/foundation.dart';

/// Abstraction for audio playback in the replay screen.
///
/// UI depends on this interface — not directly on `just_audio` or any
/// other package. When real recordings are available, implement this
/// with `just_audio` as a single-file swap.
abstract class ReplayAudioController extends ChangeNotifier {
  /// Loads audio from the given [uri].
  Future<void> load(String uri);

  /// Starts or resumes playback.
  Future<void> play();

  /// Pauses playback.
  Future<void> pause();

  /// Seeks to the given [position].
  Future<void> seek(Duration position);

  /// Skips forward by [amount] (default 15 seconds).
  Future<void> skipForward({Duration amount = const Duration(seconds: 15)});

  /// Skips backward by [amount] (default 15 seconds).
  Future<void> skipBackward({Duration amount = const Duration(seconds: 15)});

  /// Sets playback speed (e.g. 1.0, 1.25, 1.5).
  Future<void> setSpeed(double speed);

  /// Current playback position.
  Duration get currentPosition;

  /// Total duration of the loaded audio.
  Duration get totalDuration;

  /// Whether audio is currently playing.
  bool get isPlaying;

  /// Whether audio has been loaded successfully.
  bool get isLoaded;

  /// Whether the controller has encountered an error.
  bool get hasError;

  /// Human-readable error message, if any.
  String? get errorMessage;
}
