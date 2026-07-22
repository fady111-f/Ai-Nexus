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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isSubmitting = false;
  bool _isSignUp = false;
  String? _entryError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _enterApp({bool isGuest = false}) async {
    if (_isSubmitting) {
      return;
    }

    setState(() {
      _isSubmitting = true;
      _entryError = null;
    });

    try {
      if (isGuest) {
        await widget.authService.signIn();
      } else {
        final email = _emailController.text.trim();
        final password = _passwordController.text.trim();

        if (email.isEmpty && password.isEmpty) {
          await widget.authService.signIn();
        } else if (email.isEmpty || password.isEmpty) {
          setState(() {
            _entryError = 'Please enter both email and password.';
            _isSubmitting = false;
          });
          return;
        } else if (_isSignUp) {
          await widget.authService.signUp(email: email, password: password);
        } else {
          await widget.authService.signIn(email: email, password: password);
        }
      }

      final onboardingCompleted =
          await widget.onboardingRepository.isOnboardingCompleted();
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
    } catch (e) {
      if (mounted) {
        final msg = e.toString();
        setState(() {
          if (msg.contains('user-not-found') || msg.contains('invalid-credential')) {
            _entryError = 'Invalid email or password.';
          } else if (msg.contains('email-already-in-use')) {
            _entryError = 'An account already exists for this email.';
          } else if (msg.contains('weak-password')) {
            _entryError = 'Password should be at least 6 characters.';
          } else if (msg.contains('invalid-email')) {
            _entryError = 'Please enter a valid email address.';
          } else {
            _entryError = 'Authentication failed. Please try again.';
          }
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
                                isSignUp: _isSignUp,
                                entryError: _entryError,
                                emailController: _emailController,
                                passwordController: _passwordController,
                                onEnterApp: () => _enterApp(isGuest: false),
                                onGuestEnter: () => _enterApp(isGuest: true),
                                onToggleMode: () => setState(() => _isSignUp = !_isSignUp),
                              )
                            : _PortraitLayout(
                                availableWidth: constraints.maxWidth,
                                availableHeight: constraints.maxHeight,
                                isSubmitting: _isSubmitting,
                                isSignUp: _isSignUp,
                                entryError: _entryError,
                                emailController: _emailController,
                                passwordController: _passwordController,
                                onEnterApp: () => _enterApp(isGuest: false),
                                onGuestEnter: () => _enterApp(isGuest: true),
                                onToggleMode: () => setState(() => _isSignUp = !_isSignUp),
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
    required this.isSignUp,
    required this.entryError,
    required this.emailController,
    required this.passwordController,
    required this.onEnterApp,
    required this.onGuestEnter,
    required this.onToggleMode,
  });

  final double availableWidth;
  final double availableHeight;
  final bool isSubmitting;
  final bool isSignUp;
  final String? entryError;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onEnterApp;
  final VoidCallback onGuestEnter;
  final VoidCallback onToggleMode;

  @override
  Widget build(BuildContext context) {
    final compact = availableWidth < 370 || availableHeight < 700;
    final orbSize = compact ? 112.0 : 144.0;
    final sectionGap = compact ? MockMateSpacing.medium : MockMateSpacing.large;

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
            SizedBox(height: compact ? 12 : 24),
            Center(child: MockMateVoiceOrb(size: orbSize)),
            SizedBox(height: compact ? 12 : 20),
            _HeroCopy(compact: compact, centered: true),
            SizedBox(height: sectionGap),
            _SignInPanel(
              isSubmitting: isSubmitting,
              isSignUp: isSignUp,
              entryError: entryError,
              emailController: emailController,
              passwordController: passwordController,
              onEnterApp: onEnterApp,
              onGuestEnter: onGuestEnter,
              onToggleMode: onToggleMode,
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
    required this.isSignUp,
    required this.entryError,
    required this.emailController,
    required this.passwordController,
    required this.onEnterApp,
    required this.onGuestEnter,
    required this.onToggleMode,
  });

  final bool isSubmitting;
  final bool isSignUp;
  final String? entryError;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onEnterApp;
  final VoidCallback onGuestEnter;
  final VoidCallback onToggleMode;

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
                      MockMateVoiceOrb(size: 120),
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
                isSignUp: isSignUp,
                entryError: entryError,
                emailController: emailController,
                passwordController: passwordController,
                onEnterApp: onEnterApp,
                onGuestEnter: onGuestEnter,
                onToggleMode: onToggleMode,
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
          ).textTheme.displaySmall?.copyWith(fontSize: compact ? 26 : 36),
        ),
        const SizedBox(height: MockMateSpacing.small),
        Text(
          'Practice real interviews. Get challenged.\nKnow exactly what to improve.',
          textAlign: textAlign,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontSize: compact ? 13 : 15),
        ),
      ],
    );
  }
}

class _SignInPanel extends StatelessWidget {
  const _SignInPanel({
    required this.isSubmitting,
    required this.isSignUp,
    required this.entryError,
    required this.emailController,
    required this.passwordController,
    required this.onEnterApp,
    required this.onGuestEnter,
    required this.onToggleMode,
    required this.compact,
  });

  final bool isSubmitting;
  final bool isSignUp;
  final String? entryError;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onEnterApp;
  final VoidCallback onGuestEnter;
  final VoidCallback onToggleMode;
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
        padding: EdgeInsets.all(compact ? 16 : MockMateSpacing.large),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              isSignUp ? 'Create Account' : 'Welcome back',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: MockMateSpacing.xSmall),
            Text(
              isSignUp
                  ? 'Sign up to sync your interview progress'
                  : 'Ready to practice your next interview?',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: MockMateSpacing.medium),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                labelText: 'Email Address',
                hintText: 'name@example.com',
                isDense: true,
                filled: true,
                fillColor: MockMateColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: MockMateColors.outline),
                ),
              ),
            ),
            const SizedBox(height: MockMateSpacing.small),
            TextField(
              controller: passwordController,
              obscureText: true,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: '••••••••',
                isDense: true,
                filled: true,
                fillColor: MockMateColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: MockMateColors.outline),
                ),
              ),
            ),
            const SizedBox(height: MockMateSpacing.medium),
            Semantics(
              button: true,
              child: ElevatedButton(
                key: const Key('signInButton'),
                onPressed: isSubmitting ? null : onEnterApp,
                child: Text(isSignUp ? 'Sign Up' : 'Sign In'),
              ),
            ),
            const SizedBox(height: MockMateSpacing.xSmall),
            TextButton(
              onPressed: isSubmitting ? null : onToggleMode,
              child: Text(
                isSignUp
                    ? 'Already have an account? Sign In'
                    : "Don't have an account? Sign Up",
                style: const TextStyle(color: MockMateColors.primary, fontSize: 13),
              ),
            ),
            const Divider(color: MockMateColors.outline, height: 24),
            Semantics(
              button: true,
              child: OutlinedButton(
                key: const Key('guestButton'),
                onPressed: isSubmitting ? null : onGuestEnter,
                child: const Text('Continue as Guest'),
              ),
            ),
            if (entryError != null) ...[
              const SizedBox(height: MockMateSpacing.small),
              Text(
                entryError!,
                key: const Key('signInEntryError'),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 12,
                ),
              ),
            ],
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

