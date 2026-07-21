import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mockmate/core/routing/app_routes.dart';
import 'package:mockmate/core/theme/mockmate_theme.dart';
import 'package:mockmate/features/auth/presentation/widgets/mockmate_brand.dart';
import 'package:mockmate/features/home/presentation/widgets/home_header.dart';
import 'package:mockmate/features/home/presentation/widgets/interview_dna_preview.dart';
import 'package:mockmate/features/home/presentation/widgets/profile_setup_summary.dart';
import 'package:mockmate/features/home/presentation/widgets/quick_stats.dart';
import 'package:mockmate/features/home/presentation/widgets/recent_activity.dart';
import 'package:mockmate/features/home/presentation/widgets/start_interview_card.dart';
import 'package:mockmate/features/interviews/domain/models/interview_session.dart';
import 'package:mockmate/features/interviews/domain/repositories/interview_repository.dart';
import 'package:mockmate/features/onboarding/domain/models/user_profile.dart';
import 'package:mockmate/features/onboarding/domain/repositories/onboarding_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    required this.onboardingRepository,
    required this.interviewRepository,
    super.key,
  });

  final OnboardingRepository onboardingRepository;
  final InterviewRepository interviewRepository;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<(UserProfile?, List<InterviewSession>)> _homeDataFuture;

  @override
  void initState() {
    super.initState();
    _homeDataFuture = _loadHomeData();
  }

  Future<(UserProfile?, List<InterviewSession>)> _loadHomeData() async {
    if (kDebugMode) {
      await widget.interviewRepository.seedDemoSessions();
    }
    final profile = await widget.onboardingRepository.loadUserProfile();
    final sessions = await widget.interviewRepository.getSessions();
    return (profile, sessions);
  }

  void _retryProfileLoad() {
    setState(() {
      _homeDataFuture = _loadHomeData();
    });
  }

  void _returnToOnboarding() {
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutes.onboarding, (route) => false);
  }

  void _handleStartInterview() {
    Navigator.of(context).pushNamed(AppRoutes.setup);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<(UserProfile?, List<InterviewSession>)>(
      future: _homeDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const _HomeLoadingState();
        }
        if (snapshot.hasError) {
          return _HomeStatusState(
            icon: Icons.cloud_off_outlined,
            title: "We couldn't load your profile.",
            message: 'Your setup is still safe. Try loading it again.',
            actionLabel: 'Try Again',
            actionKey: const Key('homeRetryButton'),
            onAction: _retryProfileLoad,
          );
        }

        final data = snapshot.data;
        if (data == null || data.$1 == null) {
          return _HomeStatusState(
            icon: Icons.person_search_outlined,
            title: 'Your setup is incomplete.',
            message:
                'Complete onboarding so Gahez? can personalize your dashboard.',
            actionLabel: 'Complete Setup',
            actionKey: const Key('returnToOnboardingButton'),
            onAction: _returnToOnboarding,
          );
        }

        return _HomeDashboard(
          profile: data.$1!,
          sessions: data.$2,
          onStartInterview: _handleStartInterview,
        );
      },
    );
  }
}

class _HomeDashboard extends StatelessWidget {
  const _HomeDashboard({
    required this.profile,
    required this.sessions,
    required this.onStartInterview,
  });

  final UserProfile profile;
  final List<InterviewSession> sessions;
  final VoidCallback onStartInterview;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: _HomeBackground()),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth >= 760;
                final horizontalPadding = constraints.maxWidth < 360
                    ? MockMateSpacing.medium
                    : constraints.maxWidth >= 1000
                    ? MockMateSpacing.xxLarge
                    : MockMateSpacing.large;
                final sectionGap = constraints.maxHeight < 620
                    ? MockMateSpacing.large
                    : MockMateSpacing.xLarge;

                return CustomScrollView(
                  key: const Key('homeDashboard'),
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        MockMateSpacing.large,
                        horizontalPadding,
                        MockMateSpacing.xxLarge,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 1120),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                HomeHeader(
                                  greeting: _greetingFor(DateTime.now()),
                                  profile: profile,
                                ),
                                SizedBox(height: sectionGap),
                                StartInterviewCard(
                                  profile: profile,
                                  onStartInterview: onStartInterview,
                                ),
                                SizedBox(height: sectionGap),
                                QuickStats(sessions: sessions),
                                SizedBox(height: sectionGap),
                                if (wide)
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: InterviewDnaPreview(hasSessions: sessions.isNotEmpty),
                                      ),
                                      const SizedBox(
                                        width: MockMateSpacing.large,
                                      ),
                                      Expanded(
                                        child: RecentActivity(
                                          sessions: sessions,
                                          onStartInterview: onStartInterview,
                                        ),
                                      ),
                                    ],
                                  )
                                else ...[
                                  InterviewDnaPreview(hasSessions: sessions.isNotEmpty),
                                  SizedBox(height: sectionGap),
                                  RecentActivity(
                                    sessions: sessions,
                                    onStartInterview: onStartInterview,
                                  ),
                                ],
                                SizedBox(height: sectionGap),
                                ProfileSetupSummary(profile: profile),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  static String _greetingFor(DateTime now) => switch (now.hour) {
    < 12 => 'Good morning',
    < 18 => 'Good afternoon',
    _ => 'Good evening',
  };
}

class _HomeLoadingState extends StatelessWidget {
  const _HomeLoadingState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key('homeLoadingState'),
      body: SafeArea(
        child: Semantics(
          label: 'Loading your personalized MockMate dashboard',
          child: SingleChildScrollView(
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 920),
                child: Padding(
                  padding: const EdgeInsets.all(MockMateSpacing.large),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: MockMateBrand(compact: true),
                      ),
                      const SizedBox(height: MockMateSpacing.xLarge),
                      const _SkeletonBlock(widthFactor: 0.48, height: 30),
                      const SizedBox(height: MockMateSpacing.small),
                      const _SkeletonBlock(widthFactor: 0.7, height: 16),
                      const SizedBox(height: MockMateSpacing.xLarge),
                      const _SkeletonBlock(height: 230, radius: 26),
                      const SizedBox(height: MockMateSpacing.large),
                      Row(
                        children: [
                          const Expanded(child: _SkeletonBlock(height: 92)),
                          const SizedBox(width: MockMateSpacing.small),
                          Expanded(
                            child: _SkeletonBlock(
                              height: 92,
                              color: MockMateColors.primary.withValues(
                                alpha: 0.08,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SkeletonBlock extends StatelessWidget {
  const _SkeletonBlock({
    required this.height,
    this.widthFactor = 1,
    this.radius = 16,
    this.color = MockMateColors.surface,
  });

  final double height;
  final double widthFactor;
  final double radius;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      alignment: Alignment.centerLeft,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: MockMateColors.outline),
        ),
      ),
    );
  }
}

class _HomeStatusState extends StatelessWidget {
  const _HomeStatusState({
    required this.icon,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.actionKey,
    required this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String actionLabel;
  final Key actionKey;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(MockMateSpacing.large),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: MockMateBrand(compact: true),
              ),
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 440),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: MockMateColors.surface,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: MockMateColors.outline),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(MockMateSpacing.large),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 54,
                              height: 54,
                              decoration: BoxDecoration(
                                color: MockMateColors.surfaceRaised,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Icon(
                                icon,
                                color: MockMateColors.cyan,
                                size: 26,
                              ),
                            ),
                            const SizedBox(height: MockMateSpacing.large),
                            Text(
                              title,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: MockMateSpacing.xSmall),
                            Text(
                              message,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: MockMateSpacing.large),
                            ElevatedButton(
                              key: actionKey,
                              onPressed: onAction,
                              child: Text(actionLabel),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeBackground extends StatelessWidget {
  const _HomeBackground();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: const _HomeBackgroundPainter());
  }
}

class _HomeBackgroundPainter extends CustomPainter {
  const _HomeBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final glow = Paint()
      ..color = MockMateColors.primary.withValues(alpha: 0.055)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 110);
    canvas.drawCircle(Offset(size.width * 0.82, size.height * 0.08), 150, glow);

    final line = Paint()
      ..color = MockMateColors.outline.withValues(alpha: 0.18)
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(size.width * 0.12, 0),
      Offset(size.width * 0.35, size.height),
      line,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
