import 'package:flutter/material.dart';
import 'package:mockmate/core/theme/mockmate_theme.dart';
import 'package:mockmate/features/interviews/domain/models/interview_session.dart';
import 'package:mockmate/features/interviews/domain/repositories/interview_repository.dart';
import 'package:mockmate/features/replay/data/stub_replay_audio_controller.dart';
import 'package:mockmate/features/replay/presentation/widgets/replay_header.dart';
import 'package:mockmate/features/replay/presentation/widgets/replay_score_summary.dart';
import 'package:mockmate/features/replay/presentation/widgets/replay_timeline.dart';

class InterviewReplayPage extends StatefulWidget {
  const InterviewReplayPage({
    required this.sessionId,
    required this.interviewRepository,
    super.key,
  });

  final String sessionId;
  final InterviewRepository interviewRepository;

  @override
  State<InterviewReplayPage> createState() => _InterviewReplayPageState();
}

class _InterviewReplayPageState extends State<InterviewReplayPage> {
  late Future<InterviewSession?> _sessionFuture;
  final _audioController = StubReplayAudioController();

  @override
  void initState() {
    super.initState();
    _sessionFuture = widget.interviewRepository.getSessionById(widget.sessionId);
  }

  Future<void> _toggleBookmark(String questionId, bool isBookmarked) async {
    await widget.interviewRepository.updateQuestionBookmark(
      sessionId: widget.sessionId,
      questionId: questionId,
      isBookmarked: isBookmarked,
    );
    // Reload session to reflect updated state
    setState(() {
      _sessionFuture = widget.interviewRepository.getSessionById(widget.sessionId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Interview Replay'),
        backgroundColor: Colors.transparent,
      ),
      body: FutureBuilder<InterviewSession?>(
        future: _sessionFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || snapshot.data == null) {
            return const Center(child: Text('Session not found or error loading.'));
          }

          final session = snapshot.data!;

          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(MockMateSpacing.large),
                sliver: SliverToBoxAdapter(
                  child: ReplayHeader(session: session),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: MockMateSpacing.large),
                sliver: SliverToBoxAdapter(
                  child: _AudioPlayerWidget(controller: _audioController),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(MockMateSpacing.large),
                sliver: SliverToBoxAdapter(
                  child: ReplayScoreSummary(session: session),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: MockMateSpacing.large),
                sliver: SliverToBoxAdapter(
                  child: Text('Transcript & Timeline', style: Theme.of(context).textTheme.titleLarge),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(MockMateSpacing.large),
                sliver: SliverToBoxAdapter(
                  child: ReplayTimeline(
                    session: session,
                    onToggleBookmark: _toggleBookmark,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: MockMateSpacing.xxLarge)),
            ],
          );
        },
      ),
    );
  }
}

class _AudioPlayerWidget extends StatelessWidget {
  const _AudioPlayerWidget({required this.controller});

  final StubReplayAudioController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(MockMateSpacing.large),
      decoration: BoxDecoration(
        color: MockMateColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: MockMateColors.outline),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: MockMateColors.surfaceRaised,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.mic_off_rounded, color: MockMateColors.textSecondary),
          ),
          const SizedBox(width: MockMateSpacing.large),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recording unavailable',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 2),
                Text(
                  'Audio recording was not enabled for this session.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: MockMateColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
