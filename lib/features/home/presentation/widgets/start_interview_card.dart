import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:mockmate/core/theme/mockmate_theme.dart';
import 'package:mockmate/features/onboarding/domain/models/user_profile.dart';

class StartInterviewCard extends StatelessWidget {
  const StartInterviewCard({
    required this.profile,
    required this.onStartInterview,
    super.key,
  });

  final UserProfile profile;
  final VoidCallback onStartInterview;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            MockMateColors.primary.withValues(alpha: 0.21),
            MockMateColors.surfaceRaised,
            MockMateColors.surface,
          ],
          stops: const [0, 0.56, 1],
        ),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: MockMateColors.primary.withValues(alpha: 0.35),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 680;
            final veryNarrow = constraints.maxWidth < 360;
            return Stack(
              children: [
                const Positioned(
                  right: -30,
                  top: -34,
                  child: _HeroSignalPattern(size: 190),
                ),
                Padding(
                  padding: EdgeInsets.all(wide ? 28 : MockMateSpacing.large),
                  child: wide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(child: _HeroCopy(profile: profile)),
                            const SizedBox(width: MockMateSpacing.xLarge),
                            const _VoiceEmblem(size: 126),
                            const SizedBox(width: MockMateSpacing.large),
                            SizedBox(
                              width: 230,
                              child: _StartButton(onPressed: onStartInterview),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (veryNarrow)
                              _HeroCopy(profile: profile)
                            else
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(child: _HeroCopy(profile: profile)),
                                  const SizedBox(width: MockMateSpacing.small),
                                  const _VoiceEmblem(size: 76),
                                ],
                              ),
                            const SizedBox(height: MockMateSpacing.large),
                            _StartButton(onPressed: onStartInterview),
                          ],
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _HeroCopy extends StatelessWidget {
  const _HeroCopy({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Ready to practice?',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontSize: 25),
        ),
        const SizedBox(height: MockMateSpacing.xSmall),
        Text(
          'Start a personalized interview built around your profile.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: MockMateSpacing.medium),
        Text(
          profile.targetRole,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontSize: 17),
        ),
        const SizedBox(height: MockMateSpacing.small),
        Wrap(
          spacing: MockMateSpacing.xSmall,
          runSpacing: MockMateSpacing.xSmall,
          children: [
            _PreferencePill(
              icon: Icons.forum_outlined,
              label: profile.preferredLanguage.label,
            ),
            _PreferencePill(
              icon: Icons.tune_rounded,
              label: profile.preferredDifficulty.label,
            ),
          ],
        ),
      ],
    );
  }
}

class _PreferencePill extends StatelessWidget {
  const _PreferencePill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: MockMateColors.background.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: MockMateColors.outlineStrong),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: MockMateColors.cyan),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: MockMateColors.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _StartButton extends StatelessWidget {
  const _StartButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Start New Interview',
      child: Material(
        color: MockMateColors.primaryStrong,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          key: const Key('startInterviewButton'),
          onTap: onPressed,
          overlayColor: WidgetStatePropertyAll(
            Colors.white.withValues(alpha: 0.1),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 56),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.mic_none_rounded, size: 21),
                  SizedBox(width: 9),
                  Flexible(
                    child: Text(
                      'Start New Interview',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(width: 9),
                  Icon(Icons.arrow_forward_rounded, size: 19),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _VoiceEmblem extends StatelessWidget {
  const _VoiceEmblem({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: 'MockMate voice interview signal',
      child: CustomPaint(
        size: Size.square(size),
        painter: const _VoiceEmblemPainter(),
      ),
    );
  }
}

class _VoiceEmblemPainter extends CustomPainter {
  const _VoiceEmblemPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2;
    final ring = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (var index = 0; index < 3; index++) {
      ring.color = MockMateColors.primary.withValues(alpha: 0.2 - index * 0.05);
      canvas.drawCircle(center, radius * (0.68 + index * 0.14), ring);
    }

    final core = Paint()
      ..shader = ui.Gradient.radial(
        center.translate(-radius * 0.18, -radius * 0.2),
        radius,
        const [MockMateColors.primary, Color(0xFF27234F), Color(0xFF11151C)],
        const [0, 0.64, 1],
      );
    canvas.drawCircle(center, radius * 0.62, core);

    final wave = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = math.max(2, size.width * 0.028);
    for (var index = -3; index <= 3; index++) {
      final height = radius * (0.18 + (3 - index.abs()) * 0.075);
      wave.color = Color.lerp(
        MockMateColors.textPrimary,
        MockMateColors.cyan,
        (index + 3) / 6,
      )!;
      final x = center.dx + index * radius * 0.16;
      canvas.drawLine(
        Offset(x, center.dy - height),
        Offset(x, center.dy + height),
        wave,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _HeroSignalPattern extends StatelessWidget {
  const _HeroSignalPattern({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: CustomPaint(
        size: Size.square(size),
        painter: const _HeroSignalPatternPainter(),
      ),
    );
  }
}

class _HeroSignalPatternPainter extends CustomPainter {
  const _HeroSignalPatternPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (var index = 1; index <= 4; index++) {
      paint.color = MockMateColors.cyan.withValues(alpha: 0.035 * (5 - index));
      canvas.drawCircle(center, size.width * 0.11 * index, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
