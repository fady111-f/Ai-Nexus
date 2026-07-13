import 'package:flutter/material.dart';
import 'package:mockmate/core/routing/app_routes.dart';
import 'package:mockmate/core/theme/mockmate_theme.dart';
import 'package:mockmate/features/auth/domain/auth_service.dart';
import 'package:mockmate/features/auth/presentation/widgets/mockmate_brand.dart';
import 'package:mockmate/features/auth/presentation/widgets/mockmate_voice_orb.dart';
import 'package:mockmate/features/onboarding/domain/repositories/onboarding_repository.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({
    required this.authService,
    required this.onboardingRepository,
    super.key,
  });

  final AuthService authService;
  final OnboardingRepository onboardingRepository;

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _isSubmitting = false;
  String? _entryError;

  Future<void> _enterApp() async {
    if (_isSubmitting) {
      return;
    }

    setState(() {
      _isSubmitting = true;
      _entryError = null;
    });
    try {
      await widget.authService.signIn();
      final onboardingCompleted = await widget.onboardingRepository
          .isOnboardingCompleted();
      if (!mounted) {
        return;
      }
      if (onboardingCompleted) {
        await Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
      } else {
        await Navigator.of(context).pushNamed(AppRoutes.onboarding);
      }
    } on Object {
      if (mounted) {
        setState(() {
          _entryError = 'We could not continue right now. Please try again.';
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: _AmbientBackground()),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isLandscape =
                    constraints.maxWidth >= 700 &&
                    constraints.maxWidth > constraints.maxHeight * 1.3;
                final horizontalPadding = constraints.maxWidth >= 900
                    ? MockMateSpacing.xxLarge
                    : MockMateSpacing.large;

                return CustomScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  slivers: [
                    SliverPadding(
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        MockMateSpacing.large,
                        horizontalPadding,
                        MockMateSpacing.large,
                      ),
                      sliver: SliverFillRemaining(
                        hasScrollBody: false,
                        child: isLandscape
                            ? _LandscapeLayout(
                                isSubmitting: _isSubmitting,
                                entryError: _entryError,
                                onEnterApp: _enterApp,
                              )
                            : _PortraitLayout(
                                availableWidth: constraints.maxWidth,
                                availableHeight: constraints.maxHeight,
                                isSubmitting: _isSubmitting,
                                entryError: _entryError,
                                onEnterApp: _enterApp,
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
}

class _PortraitLayout extends StatelessWidget {
  const _PortraitLayout({
    required this.availableWidth,
    required this.availableHeight,
    required this.isSubmitting,
    required this.entryError,
    required this.onEnterApp,
  });

  final double availableWidth;
  final double availableHeight;
  final bool isSubmitting;
  final String? entryError;
  final VoidCallback onEnterApp;

  @override
  Widget build(BuildContext context) {
    final compact = availableWidth < 370 || availableHeight < 700;
    final orbSize = compact ? 132.0 : 168.0;
    final sectionGap = compact ? MockMateSpacing.large : MockMateSpacing.xLarge;

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: MockMateBrand(compact: compact),
            ),
            SizedBox(height: compact ? 20 : 36),
            Center(child: MockMateVoiceOrb(size: orbSize)),
            SizedBox(height: compact ? 20 : 28),
            _HeroCopy(compact: compact, centered: true),
            SizedBox(height: sectionGap),
            _SignInPanel(
              isSubmitting: isSubmitting,
              entryError: entryError,
              onEnterApp: onEnterApp,
              compact: compact,
            ),
          ],
        ),
      ),
    );
  }
}

class _LandscapeLayout extends StatelessWidget {
  const _LandscapeLayout({
    required this.isSubmitting,
    required this.entryError,
    required this.onEnterApp,
  });

  final bool isSubmitting;
  final String? entryError;
  final VoidCallback onEnterApp;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1060),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const MockMateBrand(compact: true),
                  const SizedBox(height: MockMateSpacing.large),
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      MockMateVoiceOrb(size: 132),
                      SizedBox(width: MockMateSpacing.large),
                      Expanded(child: _HeroCopy(compact: true)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: MockMateSpacing.xxLarge),
            SizedBox(
              width: 380,
              child: _SignInPanel(
                isSubmitting: isSubmitting,
                entryError: entryError,
                onEnterApp: onEnterApp,
                compact: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroCopy extends StatelessWidget {
  const _HeroCopy({this.compact = false, this.centered = false});

  final bool compact;
  final bool centered;

  @override
  Widget build(BuildContext context) {
    final textAlign = centered ? TextAlign.center : TextAlign.left;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: centered
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(
          'Your toughest interview\nbefore the real one.',
          textAlign: textAlign,
          style: Theme.of(
            context,
          ).textTheme.displaySmall?.copyWith(fontSize: compact ? 32 : 42),
        ),
        const SizedBox(height: MockMateSpacing.medium),
        Text(
          'Practice real interviews. Get challenged.\nKnow exactly what to improve.',
          textAlign: textAlign,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontSize: compact ? 14 : 16),
        ),
      ],
    );
  }
}

class _SignInPanel extends StatelessWidget {
  const _SignInPanel({
    required this.isSubmitting,
    required this.entryError,
    required this.onEnterApp,
    required this.compact,
  });

  final bool isSubmitting;
  final String? entryError;
  final VoidCallback onEnterApp;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: MockMateColors.surface.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: MockMateColors.outline),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 32,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(compact ? 20 : MockMateSpacing.large),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Welcome back', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: MockMateSpacing.xSmall),
            Text(
              'Ready to practice your next interview?',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: MockMateSpacing.large),
            Semantics(
              button: true,
              child: ElevatedButton(
                key: const Key('signInButton'),
                onPressed: isSubmitting ? null : onEnterApp,
                child: const Text('Sign In'),
              ),
            ),
            const SizedBox(height: MockMateSpacing.small),
            Semantics(
              button: true,
              child: OutlinedButton(
                key: const Key('guestButton'),
                onPressed: isSubmitting ? null : onEnterApp,
                child: const Text('Continue as Guest'),
              ),
            ),
            const SizedBox(height: MockMateSpacing.medium),
            if (entryError != null) ...[
              Text(
                entryError!,
                key: const Key('signInEntryError'),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: MockMateSpacing.small),
            ],
            Text(
              'Secure authentication will be enabled in a future release.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: MockMateColors.textSecondary.withValues(alpha: 0.72),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AmbientBackground extends StatelessWidget {
  const _AmbientBackground();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: const _AmbientBackgroundPainter());
  }
}

class _AmbientBackgroundPainter extends CustomPainter {
  const _AmbientBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final glow = Paint()
      ..color = MockMateColors.primary.withValues(alpha: 0.08)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 90);
    canvas.drawCircle(Offset(size.width * 0.53, size.height * 0.27), 120, glow);

    final line = Paint()
      ..color = MockMateColors.outline.withValues(alpha: 0.28)
      ..strokeWidth = 1;
    final path = Path()
      ..moveTo(0, size.height * 0.68)
      ..cubicTo(
        size.width * 0.28,
        size.height * 0.62,
        size.width * 0.72,
        size.height * 0.76,
        size.width,
        size.height * 0.69,
      );
    canvas.drawPath(path, line);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
