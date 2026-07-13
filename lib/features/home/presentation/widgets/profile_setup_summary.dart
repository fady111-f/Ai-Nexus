import 'package:flutter/material.dart';
import 'package:mockmate/core/theme/mockmate_theme.dart';
import 'package:mockmate/features/onboarding/domain/models/user_profile.dart';

class ProfileSetupSummary extends StatelessWidget {
  const ProfileSetupSummary({required this.profile, super.key});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    final items = [
      ('Career Field', profile.careerField.label, Icons.category_outlined),
      ('Experience', profile.experienceLevel.label, Icons.stairs_outlined),
      ('Language', profile.preferredLanguage.label, Icons.translate_rounded),
      ('Difficulty', profile.preferredDifficulty.label, Icons.tune_rounded),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Your Setup', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: MockMateSpacing.small),
        DecoratedBox(
          key: const Key('profileSetupSummary'),
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
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: MockMateColors.primary.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Icon(
                        Icons.work_outline_rounded,
                        color: MockMateColors.primary,
                        size: 21,
                      ),
                    ),
                    const SizedBox(width: MockMateSpacing.small),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Target Role',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(fontSize: 12),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            profile.targetRole,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: MockMateSpacing.large,
                  ),
                  child: Divider(height: 1, color: MockMateColors.outline),
                ),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final columns = constraints.maxWidth >= 680 ? 4 : 2;
                    const gap = MockMateSpacing.medium;
                    final itemWidth =
                        (constraints.maxWidth - gap * (columns - 1)) / columns;
                    return Wrap(
                      spacing: gap,
                      runSpacing: MockMateSpacing.large,
                      children: items
                          .map(
                            (item) => SizedBox(
                              width: itemWidth,
                              child: _SetupItem(
                                label: item.$1,
                                value: item.$2,
                                icon: item.$3,
                              ),
                            ),
                          )
                          .toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SetupItem extends StatelessWidget {
  const _SetupItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 17, color: MockMateColors.textSecondary),
        const SizedBox(width: MockMateSpacing.xSmall),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontSize: 11),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
