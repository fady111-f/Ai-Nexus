import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mockmate/core/theme/mockmate_theme.dart';
import 'package:mockmate/features/interviews/domain/models/interview_session.dart';

class ReplayHeader extends StatelessWidget {
  const ReplayHeader({required this.session, super.key});

  final InterviewSession session;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          session.jobTitle,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        if (session.companyName != null) ...[
          const SizedBox(height: MockMateSpacing.xSmall),
          Text(
            session.companyName!,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: MockMateColors.textSecondary,
                ),
          ),
        ],
        const SizedBox(height: MockMateSpacing.medium),
        Row(
          children: [
            Icon(
              Icons.calendar_today_rounded,
              size: 16,
              color: MockMateColors.textSecondary.withValues(alpha: 0.8),
            ),
            const SizedBox(width: 8),
            Text(
              DateFormat.yMMMd().format(session.startedAt),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(width: MockMateSpacing.large),
            Icon(
              Icons.timer_outlined,
              size: 16,
              color: MockMateColors.textSecondary.withValues(alpha: 0.8),
            ),
            const SizedBox(width: 8),
            Text(
              '${session.duration.inMinutes} min',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ],
    );
  }
}
