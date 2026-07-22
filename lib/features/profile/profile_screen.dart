import 'package:flutter/material.dart';
import 'package:mockmate/core/routing/app_routes.dart';
import 'package:mockmate/core/theme/mockmate_theme.dart';
import 'package:mockmate/features/auth/domain/auth_service.dart';
import 'package:mockmate/features/interviews/domain/models/interview_session.dart';
import 'package:mockmate/features/interviews/domain/repositories/interview_repository.dart';
import 'package:mockmate/features/onboarding/domain/models/user_profile.dart';
import 'package:mockmate/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'widgets/profile_menu_item.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    required this.onboardingRepository,
    required this.interviewRepository,
    required this.authService,
    super.key,
  });

  final OnboardingRepository onboardingRepository;
  final InterviewRepository interviewRepository;
  final AuthService authService;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<(UserProfile?, List<InterviewSession>)> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = _loadData();
  }

  Future<(UserProfile?, List<InterviewSession>)> _loadData() async {
    final profile = await widget.onboardingRepository.loadUserProfile();
    final sessions = await widget.interviewRepository.getSessions();
    return (profile, sessions);
  }

  Future<void> _handleSignOut() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: MockMateColors.surface,
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Sign Out',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await widget.authService.signOut();
      if (mounted) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(AppRoutes.signIn, (route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MockMateColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: FutureBuilder<(UserProfile?, List<InterviewSession>)>(
        future: _dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || snapshot.data == null) {
            return Center(
              child: Text(
                'Could not load profile.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          }

          final profile = snapshot.data!.$1;
          final sessions = snapshot.data!.$2;

          if (profile == null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.person_off_outlined,
                      size: 48, color: MockMateColors.textSecondary),
                  const SizedBox(height: MockMateSpacing.medium),
                  Text(
                    'No profile found.',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: MockMateSpacing.xSmall),
                  Text(
                    'Complete onboarding to set up your profile.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }

          final totalMinutes = sessions.fold<int>(
            0,
            (sum, s) => sum + s.duration.inMinutes,
          );
          final practiceLabel = totalMinutes >= 60
              ? '${(totalMinutes / 60).toStringAsFixed(1)} hr'
              : '$totalMinutes min';
          final email = widget.authService.currentUserEmail;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Avatar & name
                Center(
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              MockMateColors.primary,
                              MockMateColors.primaryStrong,
                            ],
                          ),
                        ),
                        child: const CircleAvatar(
                          radius: 45,
                          backgroundColor: MockMateColors.surface,
                          child: Icon(Icons.person,
                              size: 45, color: MockMateColors.textPrimary),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        profile.targetRole,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      if (email != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          email,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Stats
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: MockMateColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: MockMateColors.outline),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatItem('Interviews', '${sessions.length}'),
                      Container(
                          width: 1, height: 30, color: MockMateColors.outline),
                      _buildStatItem('Practice Time', practiceLabel),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Menu
                Container(
                  decoration: BoxDecoration(
                    color: MockMateColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: MockMateColors.outline),
                  ),
                  child: Column(
                    children: [
                      ProfileMenuItem(
                        icon: Icons.badge_outlined,
                        title:
                            'Setup Details (${profile.careerField.label})',
                        onTap: () {},
                      ),
                      const Divider(
                          color: MockMateColors.outline, height: 1),
                      ProfileMenuItem(
                        icon: Icons.description_outlined,
                        title: 'Manage CV',
                        onTap: () =>
                            Navigator.pushNamed(context, AppRoutes.cvManager),
                      ),
                      const Divider(
                          color: MockMateColors.outline, height: 1),
                      ProfileMenuItem(
                        icon: Icons.settings_outlined,
                        title: 'Account Settings',
                        onTap: () {},
                      ),
                      const Divider(
                          color: MockMateColors.outline, height: 1),
                      ProfileMenuItem(
                        icon: Icons.logout,
                        title: 'Sign Out',
                        isDestructive: true,
                        onTap: _handleSignOut,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: MockMateColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: MockMateColors.textSecondary,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
