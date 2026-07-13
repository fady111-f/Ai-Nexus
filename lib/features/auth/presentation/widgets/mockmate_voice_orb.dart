import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:mockmate/core/theme/mockmate_theme.dart';

class MockMateVoiceOrb extends StatefulWidget {
  const MockMateVoiceOrb({this.size = 168, super.key});

  final double size;

  @override
  State<MockMateVoiceOrb> createState() => _MockMateVoiceOrbState();
}

class _MockMateVoiceOrbState extends State<MockMateVoiceOrb>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 7),
  );

  bool _reduceMotion = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (_reduceMotion == reduceMotion && _controller.isAnimating) {
      return;
    }

    _reduceMotion = reduceMotion;
    if (_reduceMotion) {
      _controller
        ..stop()
        ..value = 0.32;
    } else {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: 'Ambient voice conversation indicator',
      child: RepaintBoundary(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) => CustomPaint(
            size: Size.square(widget.size),
            painter: _VoiceOrbPainter(phase: _controller.value),
          ),
        ),
      ),
    );
  }
}

class _VoiceOrbPainter extends CustomPainter {
  const _VoiceOrbPainter({required this.phase});

  final double phase;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final shortest = size.shortestSide;
    final pulse = (math.sin(phase * math.pi * 2) + 1) / 2;
    final drift = math.sin(phase * math.pi * 4) * shortest * 0.012;

    final glow = Paint()
      ..color = MockMateColors.primary.withValues(alpha: 0.18 + pulse * 0.05)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, shortest * 0.12);
    canvas.drawCircle(center, shortest * (0.32 + pulse * 0.018), glow);

    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (var index = 0; index < 3; index++) {
      final opacity = 0.16 - index * 0.035;
      ringPaint.color = MockMateColors.primary.withValues(alpha: opacity);
      canvas.drawCircle(
        center,
        shortest * (0.34 + index * 0.085 + pulse * 0.012),
        ringPaint,
      );
    }

    final coreRect = Rect.fromCircle(
      center: center.translate(drift, -drift * 0.45),
      radius: shortest * 0.295,
    );
    final core = Paint()
      ..shader = ui.Gradient.radial(
        coreRect.center.translate(-shortest * 0.08, -shortest * 0.1),
        shortest * 0.42,
        const [Color(0xFF8C82FF), Color(0xFF4F46C7), Color(0xFF181A3D)],
        const [0, 0.48, 1],
      );
    canvas.drawCircle(coreRect.center, coreRect.width / 2, core);

    final highlight = Paint()
      ..color = Colors.white.withValues(alpha: 0.12)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, shortest * 0.035);
    canvas.drawCircle(
      coreRect.center.translate(-shortest * 0.09, -shortest * 0.11),
      shortest * 0.075,
      highlight,
    );

    canvas.save();
    canvas.clipPath(
      Path()..addOval(
        Rect.fromCircle(center: coreRect.center, radius: shortest * 0.27),
      ),
    );
    final wavePaint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = shortest * 0.022;
    for (var index = -3; index <= 3; index++) {
      final distance = index.abs();
      final wave = math.sin((phase * 2 + index * 0.17) * math.pi * 2);
      final height = shortest * (0.07 + (3 - distance) * 0.021 + wave * 0.01);
      final x = coreRect.center.dx + index * shortest * 0.045;
      wavePaint.color = Color.lerp(
        MockMateColors.textPrimary,
        MockMateColors.cyan,
        (index + 3) / 6,
      )!.withValues(alpha: 0.9);
      canvas.drawLine(
        Offset(x, coreRect.center.dy - height),
        Offset(x, coreRect.center.dy + height),
        wavePaint,
      );
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _VoiceOrbPainter oldDelegate) =>
      phase != oldDelegate.phase;
}
