import 'package:flutter/material.dart';
import 'package:mockmate/core/theme/mockmate_theme.dart';
import 'package:mockmate/features/interviews/domain/services/progress_calculator.dart';

class ProgressScoreTrend extends StatelessWidget {
  const ProgressScoreTrend({required this.summary, super.key});

  final ProgressSummary summary;

  @override
  Widget build(BuildContext context) {
    if (!summary.hasTrend) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: MockMateSpacing.large),
          child: Text(
            'Score Trend',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const SizedBox(height: MockMateSpacing.medium),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: MockMateSpacing.large),
          child: Container(
            height: 200,
            padding: const EdgeInsets.all(MockMateSpacing.large),
            decoration: BoxDecoration(
              color: MockMateColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: MockMateColors.outline),
            ),
            child: CustomPaint(
              painter: _TrendPainter(points: summary.scoreTrend),
              child: const SizedBox.expand(),
            ),
          ),
        ),
      ],
    );
  }
}

class _TrendPainter extends CustomPainter {
  const _TrendPainter({required this.points});

  final List<ScoreTrendPoint> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final maxScore = 100.0;
    final minScore = 0.0;
    
    final pointSpacing = size.width / (points.length > 1 ? points.length - 1 : 1);

    final linePaint = Paint()
      ..color = MockMateColors.cyan
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          MockMateColors.cyan.withValues(alpha: 0.3),
          MockMateColors.cyan.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    final fillPath = Path();

    for (var i = 0; i < points.length; i++) {
      final point = points[i];
      final x = i * pointSpacing;
      final y = size.height - ((point.score - minScore) / (maxScore - minScore)) * size.height;

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }

      // Draw point
      canvas.drawCircle(Offset(x, y), 5, Paint()..color = MockMateColors.surfaceRaised);
      canvas.drawCircle(Offset(x, y), 3, Paint()..color = MockMateColors.cyan);
    }

    if (points.length > 1) {
      fillPath.lineTo((points.length - 1) * pointSpacing, size.height);
      fillPath.close();
      canvas.drawPath(fillPath, fillPaint);
      canvas.drawPath(path, linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _TrendPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}
