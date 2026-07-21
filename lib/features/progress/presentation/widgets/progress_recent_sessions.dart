import 'package:flutter/material.dart';
import 'package:mockmate/core/routing/app_routes.dart';
import 'package:mockmate/core/theme/mockmate_theme.dart';
import 'package:mockmate/features/interviews/domain/models/interview_session.dart';
import 'package:intl/intl.dart';

class ProgressRecentSessions extends StatelessWidget {
  const ProgressRecentSessions({required this.sessions, super.key});

  final List<InterviewSession> sessions;

  @override
  Widget build(BuildContext context) {
    if (sessions.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: MockMateSpacing.large),
          child: Text(
            'Recent Sessions',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const SizedBox(height: MockMateSpacing.medium),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: MockMateSpacing.large),
          itemCount: sessions.length,
          separatorBuilder: (_, _) => const SizedBox(height: MockMateSpacing.small),
          itemBuilder: (context, index) {
            final session = sessions[index];
            return _SessionItem(session: session);
          },
        ),
      ],
    );
  }
}

class _SessionItem extends StatelessWidget {
  const _SessionItem({required this.session});

  final InterviewSession session;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(AppRoutes.replay, arguments: session.id);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(MockMateSpacing.large),
        decoration: BoxDecoration(
          color: MockMateColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: MockMateColors.outline),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: MockMateColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.play_arrow_rounded,
                color: MockMateColors.primary,
              ),
            ),
            const SizedBox(width: MockMateSpacing.medium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.jobTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    DateFormat.yMMMd().format(session.startedAt),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: MockMateColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: MockMateSpacing.small),
            if (session.overallScore != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: MockMateColors.surfaceRaised,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: MockMateColors.outline),
                ),
                child: Text(
                  '${session.overallScore}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: MockMateColors.cyan,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              )
            else
              const Icon(Icons.chevron_right_rounded, color: MockMateColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
