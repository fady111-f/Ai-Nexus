import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mockmate/core/theme/mockmate_theme.dart';
import 'package:mockmate/features/interviews/domain/models/interview_session.dart';
import 'package:mockmate/features/interviews/domain/repositories/interview_repository.dart';
import 'package:mockmate/features/interviews/domain/services/progress_calculator.dart';
import 'package:mockmate/features/progress/presentation/widgets/progress_empty_state.dart';
import 'package:mockmate/features/progress/presentation/widgets/progress_summary_cards.dart';
import 'package:mockmate/features/progress/presentation/widgets/progress_score_trend.dart';
import 'package:mockmate/features/progress/presentation/widgets/progress_skill_breakdown.dart';
import 'package:mockmate/features/progress/presentation/widgets/progress_recent_sessions.dart';

enum ProgressTimeRange {
  allTime('All Time'),
  last30Days('Last 30 Days'),
  last7Days('Last 7 Days');

  const ProgressTimeRange(this.label);
  final String label;
}

class ProgressPage extends StatefulWidget {
  const ProgressPage({required this.interviewRepository, super.key});

  final InterviewRepository interviewRepository;

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  late Future<List<InterviewSession>> _sessionsFuture;
  ProgressTimeRange _selectedRange = ProgressTimeRange.allTime;
  static const _calculator = ProgressCalculator();

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  void _loadSessions() {
    _sessionsFuture = widget.interviewRepository.getSessions();
  }

  Future<void> _seedDemoData() async {
    await widget.interviewRepository.seedDemoSessions();
    setState(() {
      _loadSessions();
    });
  }

  DateTime? _getFromDate() {
    final now = DateTime.now();
    return switch (_selectedRange) {
      ProgressTimeRange.allTime => null,
      ProgressTimeRange.last30Days => now.subtract(const Duration(days: 30)),
      ProgressTimeRange.last7Days => now.subtract(const Duration(days: 7)),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress Dashboard'),
        backgroundColor: Colors.transparent,
      ),
      body: FutureBuilder<List<InterviewSession>>(
        future: _sessionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Failed to load progress: ${snapshot.error}'));
          }

          final allSessions = snapshot.data ?? [];
          if (allSessions.isEmpty) {
            return ProgressEmptyState(
              onSeedDemo: kDebugMode ? _seedDemoData : null,
            );
          }

          final summary = _calculator.calculate(
            allSessions,
            from: _getFromDate(),
          );

          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: MockMateSpacing.large, vertical: MockMateSpacing.medium),
                sliver: SliverToBoxAdapter(
                  child: Center(
                    child: SegmentedButton<ProgressTimeRange>(
                      segments: ProgressTimeRange.values
                          .map((r) => ButtonSegment(value: r, label: Text(r.label)))
                          .toList(),
                      selected: {_selectedRange},
                      onSelectionChanged: (set) {
                        setState(() => _selectedRange = set.first);
                      },
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: MockMateSpacing.large),
                sliver: SliverToBoxAdapter(
                  child: ProgressSummaryCards(summary: summary),
                ),
              ),
              SliverToBoxAdapter(
                child: const SizedBox(height: MockMateSpacing.xLarge),
              ),
              SliverToBoxAdapter(
                child: ProgressScoreTrend(summary: summary),
              ),
              SliverToBoxAdapter(
                child: const SizedBox(height: MockMateSpacing.xLarge),
              ),
              SliverToBoxAdapter(
                child: ProgressSkillBreakdown(summary: summary),
              ),
              SliverToBoxAdapter(
                child: const SizedBox(height: MockMateSpacing.xLarge),
              ),
              SliverToBoxAdapter(
                child: ProgressRecentSessions(sessions: summary.latestSessions),
              ),
              SliverToBoxAdapter(
                child: const SizedBox(height: MockMateSpacing.xxLarge),
              ),
            ],
          );
        },
      ),
    );
  }
}
