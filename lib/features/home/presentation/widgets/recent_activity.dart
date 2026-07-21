import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mockmate/core/routing/app_routes.dart';
import 'package:mockmate/core/theme/mockmate_theme.dart';
import 'package:mockmate/features/home/presentation/widgets/recent_interview_empty_state.dart';
import 'package:mockmate/features/interviews/domain/models/interview_session.dart';

class RecentActivity extends StatelessWidget {
  const RecentActivity({
    required this.sessions,
    required this.onStartInterview,
    super.key,
  });

  final List<InterviewSession> sessions;
  final VoidCallback onStartInterview;

  @override
  Widget build(BuildContext context) {
    if (sessions.isEmpty) {
      return RecentInterviewEmptyState(onStartInterview: onStartInterview);
    }

    final latest = sessions.first; // assumed pre-sorted by date descending

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recent Interview', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: MockMateSpacing.small),
        DecoratedBox(
          key: const Key('recentInterviewCard'),
          decoration: BoxDecoration(
            color: MockMateColors.surface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: MockMateColors.outline),
          ),
          child: Padding(
            padding: const EdgeInsets.all(MockMateSpacing.large),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: MockMateColors.primary.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.insights_rounded,
                        color: MockMateColors.primary,
                        size: 23,
                      ),
                    ),
                    const SizedBox(width: MockMateSpacing.medium),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            latest.jobTitle,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          if (latest.companyName != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              latest.companyName!,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: MockMateColors.textSecondary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (latest.overallScore != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: MockMateColors.surfaceRaised,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: MockMateColors.outline),
                        ),
                        child: Text(
                          '${latest.overallScore}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: MockMateColors.cyan,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: MockMateSpacing.medium),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 14,
                      color: MockMateColors.textSecondary.withValues(alpha: 0.8),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      DateFormat.yMMMd().format(latest.startedAt),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(width: MockMateSpacing.medium),
                    Icon(
                      Icons.timer_outlined,
                      size: 14,
                      color: MockMateColors.textSecondary.withValues(alpha: 0.8),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${latest.duration.inMinutes} min',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: MockMateSpacing.large),
                OutlinedButton.icon(
                  key: const Key('replayRecentSessionButton'),
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      AppRoutes.replay,
                      arguments: latest.id,
                    );
                  },
                  icon: const Icon(Icons.play_arrow_rounded, size: 19),
                  label: const Text('Replay Session'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
