import 'package:flutter/material.dart';
import 'package:mockmate/core/routing/app_routes.dart';
import 'package:mockmate/core/theme/mockmate_theme.dart';
import 'package:mockmate/features/auth/presentation/widgets/mockmate_brand.dart';
import 'package:mockmate/features/onboarding/domain/models/user_profile.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({required this.greeting, required this.profile, super.key});

  final String greeting;
  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const MockMateBrand(compact: true),
            const Spacer(),
            Semantics(
              image: true,
              label: 'Profile placeholder',
              child: InkWell(
              onTap: () {
              Navigator.pushNamed(context, AppRoutes.profile);
              },
               borderRadius: BorderRadius.circular(15),
                child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: MockMateColors.surface,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: MockMateColors.outline),
                ),
                child: const Icon(
                  Icons.person_outline_rounded,
                  color: MockMateColors.textSecondary,
                  size: 22,
                ),
                ),
              ), 
            ),
          ],
        ),
        const SizedBox(height: MockMateSpacing.large),
        Text(
          greeting,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: MockMateColors.cyan,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Ready for your next interview?',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontSize: 28,
            letterSpacing: -0.8,
          ),
        ),
        const SizedBox(height: MockMateSpacing.xSmall),
        Text.rich(
          TextSpan(
            text: 'Target role  ',
            children: [
              TextSpan(
                text: profile.targetRole,
                style: const TextStyle(
                  color: MockMateColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
