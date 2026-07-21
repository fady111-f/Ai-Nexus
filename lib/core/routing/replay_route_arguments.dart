/// Typed route arguments for the Interview Replay page.
///
/// The replay page loads the session by ID from [InterviewRepository],
/// rather than receiving the full mutable object.
class ReplayRouteArguments {
  const ReplayRouteArguments({required this.sessionId});

  final String sessionId;
}
