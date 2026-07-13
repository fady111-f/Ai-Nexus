import 'package:flutter/material.dart';
import 'package:mockmate/core/theme/mockmate_theme.dart';

class MockMateBrand extends StatelessWidget {
  const MockMateBrand({this.compact = false, super.key});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final markSize = compact ? 36.0 : 42.0;

    return Semantics(
      header: true,
      label: 'MockMate',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: markSize,
            height: markSize,
            decoration: BoxDecoration(
              color: MockMateColors.surfaceRaised,
              borderRadius: BorderRadius.circular(compact ? 12 : 14),
              border: Border.all(color: MockMateColors.outlineStrong),
            ),
            child: CustomPaint(painter: const _BrandMarkPainter()),
          ),
          const SizedBox(width: MockMateSpacing.small),
          Text(
            'MockMate',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: compact ? 18 : 20,
              letterSpacing: -0.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _BrandMarkPainter extends CustomPainter {
  const _BrandMarkPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = MockMateColors.textPrimary
      ..strokeCap = StrokeCap.round
      ..strokeWidth = size.width * 0.075;
    final accent = Paint()
      ..color = MockMateColors.cyan
      ..strokeCap = StrokeCap.round
      ..strokeWidth = size.width * 0.075;
    final centerY = size.height / 2;

    canvas.drawLine(
      Offset(size.width * 0.27, centerY - size.height * 0.08),
      Offset(size.width * 0.27, centerY + size.height * 0.08),
      stroke,
    );
    canvas.drawLine(
      Offset(size.width * 0.42, centerY - size.height * 0.18),
      Offset(size.width * 0.42, centerY + size.height * 0.18),
      stroke,
    );
    canvas.drawLine(
      Offset(size.width * 0.57, centerY - size.height * 0.12),
      Offset(size.width * 0.57, centerY + size.height * 0.12),
      accent,
    );
    canvas.drawCircle(
      Offset(size.width * 0.73, centerY),
      size.width * 0.045,
      accent,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
