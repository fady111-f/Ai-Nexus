import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mockmate/core/routing/app_routes.dart';
import 'package:mockmate/core/theme/mockmate_theme.dart';
import 'package:mockmate/features/home/presentation/widgets/recent_interview_empty_state.dart';
import 'package:mockmate/features/interviews/domain/models/interview_session.dart';

class RecentActivity extends StatefulWidget {
  const RecentActivity({
    required this.sessions,
    required this.onStartInterview,
    super.key,
  });

  final List<InterviewSession> sessions;
  final VoidCallback onStartInterview;

  @override
  State<RecentActivity> createState() => _RecentActivityState();
}

class _RecentActivityState extends State<RecentActivity> {
  String _selectedRole = 'All Roles';
  String _selectedDate = 'All Time';
  String _selectedType = 'All Types';
  String _selectedScore = 'All Scores';

  List<InterviewSession> get _filteredSessions {
    return widget.sessions.where((session) {
      // Filter by Role
      if (_selectedRole != 'All Roles' &&
          !session.jobTitle.toLowerCase().contains(
            _selectedRole.toLowerCase(),
          )) {
        return false;
      }
      // Filter by Type
      if (_selectedType != 'All Types' &&
          session.interviewType.label.toLowerCase() !=
              _selectedType.toLowerCase()) {
        return false;
      }
      // Filter by Score
      if (_selectedScore != 'All Scores' && session.overallScore != null) {
        final score = session.overallScore!;
        if (_selectedScore == '80+ High' && score < 80) return false;
        if (_selectedScore == '60-79 Mid' && (score < 60 || score >= 80))
          return false;
        if (_selectedScore == '<60 Low' && score >= 60) return false;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.sessions.isEmpty) {
      return RecentInterviewEmptyState(
        onStartInterview: widget.onStartInterview,
      );
    }

    final filtered = _filteredSessions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Interview History',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Text(
              '${filtered.length} session${filtered.length == 1 ? '' : 's'}',
              style: const TextStyle(
                color: MockMateColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: MockMateSpacing.small),

        // Filters Row
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildFilterDropdown(
                value: _selectedRole,
                items: [
                  'All Roles',
                  'Senior Flutter Developer',
                  'Mobile Engineer',
                  'Backend Engineer',
                ],
                onChanged: (val) => setState(() => _selectedRole = val!),
              ),
              const SizedBox(width: 8),
              _buildFilterDropdown(
                value: _selectedDate,
                items: ['All Time', 'This Week', 'This Month'],
                onChanged: (val) => setState(() => _selectedDate = val!),
              ),
              const SizedBox(width: 8),
              _buildFilterDropdown(
                value: _selectedType,
                items: ['All Types', 'Technical', 'HR', 'Behavioral'],
                onChanged: (val) => setState(() => _selectedType = val!),
              ),
              const SizedBox(width: 8),
              _buildFilterDropdown(
                value: _selectedScore,
                items: ['All Scores', '80+ High', '60-79 Mid', '<60 Low'],
                onChanged: (val) => setState(() => _selectedScore = val!),
              ),
            ],
          ),
        ),
        const SizedBox(height: MockMateSpacing.medium),

        if (filtered.isEmpty)
          DecoratedBox(
            decoration: BoxDecoration(
              color: MockMateColors.surface,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: MockMateColors.outline),
            ),
            child: Padding(
              padding: const EdgeInsets.all(MockMateSpacing.large),
              child: Column(
                children: [
                  const Icon(
                    Icons.filter_list_off_rounded,
                    color: MockMateColors.textSecondary,
                    size: 36,
                  ),
                  const SizedBox(height: MockMateSpacing.small),
                  const Text(
                    'No matching interviews found',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Try resetting your filters or start a new practice interview.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: MockMateColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: MockMateSpacing.medium),
                  OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        _selectedRole = 'All Roles';
                        _selectedDate = 'All Time';
                        _selectedType = 'All Types';
                        _selectedScore = 'All Scores';
                      });
                    },
                    icon: const Icon(Icons.refresh_rounded, size: 16),
                    label: const Text('Reset Filters'),
                  ),
                ],
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filtered.length,
            separatorBuilder: (_, _) =>
                const SizedBox(height: MockMateSpacing.small),
            itemBuilder: (context, index) {
              final session = filtered[index];
              return Container(
                decoration: BoxDecoration(
                  color: MockMateColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: MockMateColors.outline),
                ),
                padding: const EdgeInsets.all(MockMateSpacing.medium),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: MockMateColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.insights_rounded,
                        color: MockMateColors.primary,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            session.jobTitle,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  session.interviewType.label,
                                  style: const TextStyle(
                                    color: MockMateColors.cyan,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                '•',
                                style: TextStyle(
                                  color: MockMateColors.textSecondary,
                                  fontSize: 11,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  DateFormat.yMMMd().format(session.startedAt),
                                  style: const TextStyle(
                                    color: MockMateColors.textSecondary,
                                    fontSize: 11,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                '•',
                                style: TextStyle(
                                  color: MockMateColors.textSecondary,
                                  fontSize: 11,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${session.duration.inMinutes}m',
                                style: const TextStyle(
                                  color: MockMateColors.textSecondary,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (session.overallScore != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: MockMateColors.surfaceRaised,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: MockMateColors.outlineStrong,
                          ),
                        ),
                        child: Text(
                          '${session.overallScore}',
                          style: const TextStyle(
                            color: MockMateColors.cyan,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    IconButton(
                      icon: const Icon(
                        Icons.play_arrow_rounded,
                        color: MockMateColors.primary,
                      ),
                      onPressed: () {
                        Navigator.of(
                          context,
                        ).pushNamed(AppRoutes.replay, arguments: session.id);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildFilterDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: MockMateColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: MockMateColors.outlineStrong),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          dropdownColor: MockMateColors.surfaceRaised,
          icon: const Icon(
            Icons.arrow_drop_down_rounded,
            color: MockMateColors.textSecondary,
            size: 20,
          ),
          style: const TextStyle(
            color: MockMateColors.textPrimary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          onChanged: onChanged,
          items: items.map((item) {
            return DropdownMenuItem<String>(value: item, child: Text(item));
          }).toList(),
        ),
      ),
    );
  }
}
