import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mockmate/core/routing/app_routes.dart';
import 'package:mockmate/core/theme/mockmate_theme.dart';

class InterviewDnaPreview extends StatelessWidget {
  const InterviewDnaPreview({required this.hasSessions, super.key});

  final bool hasSessions;

  static const _metrics = [
    'Technical Depth',
    'Clarity',
    'Confidence',
    'Adaptability',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Your Interview DNA',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            GestureDetector(
              onTap: hasSessions ? () => Navigator.of(context).pushNamed(AppRoutes.progress) : null,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                decoration: BoxDecoration(
                  color: hasSessions ? MockMateColors.primary.withValues(alpha: 0.1) : MockMateColors.surfaceRaised,
                  borderRadius: BorderRadius.circular(99),
                  border: Border.all(color: hasSessions ? MockMateColors.primary.withValues(alpha: 0.3) : MockMateColors.outline),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      hasSessions ? Icons.arrow_forward_rounded : Icons.lock_outline_rounded,
                      size: 14,
                      color: hasSessions ? MockMateColors.primary : MockMateColors.textSecondary,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      hasSessions ? 'View Progress' : 'Locked',
                      style: TextStyle(
                        color: hasSessions ? MockMateColors.primary : MockMateColors.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: MockMateSpacing.small),
        DecoratedBox(
          key: const Key('interviewDnaEmptyState'),
          decoration: BoxDecoration(
            color: MockMateColors.surface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: MockMateColors.outline),
          ),
          child: Padding(
            padding: const EdgeInsets.all(MockMateSpacing.large),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final narrow = constraints.maxWidth < 360;
                final visual = const _DnaSkeleton(size: 126);
                final copy = _DnaCopy(metrics: _metrics);
                return narrow
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(child: _DnaSkeleton(size: 126)),
                          const SizedBox(height: MockMateSpacing.large),
                          copy,
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          visual,
                          const SizedBox(width: MockMateSpacing.large),
                          Expanded(child: copy),
                        ],
                      );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _DnaCopy extends StatelessWidget {
  const _DnaCopy({required this.metrics});

  final List<String> metrics;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your performance profile starts here',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: MockMateSpacing.xSmall),
        Text(
          'Complete your first mock interview to unlock your personalized performance profile.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: MockMateSpacing.medium),
        Wrap(
          spacing: MockMateSpacing.xSmall,
          runSpacing: MockMateSpacing.xSmall,
          children: metrics
              .map(
                (metric) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: MockMateColors.surfaceRaised,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: MockMateColors.outlineStrong,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        metric,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.copyWith(fontSize: 11),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _DnaSkeleton extends StatelessWidget {
  const _DnaSkeleton({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: 'Locked Interview DNA preview without scores',
      child: SizedBox.square(
        dimension: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: CustomPaint(painter: const _DnaSkeletonPainter()),
            ),
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: MockMateColors.surfaceRaised,
                shape: BoxShape.circle,
                border: Border.all(color: MockMateColors.outlineStrong),
              ),
              child: const Icon(
                Icons.lock_outline_rounded,
                size: 18,
                color: MockMateColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DnaSkeletonPainter extends CustomPainter {
  const _DnaSkeletonPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide * 0.45;
    const points = 6;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (var ring = 1; ring <= 3; ring++) {
      paint.color = MockMateColors.primary.withValues(
        alpha: 0.07 + ring * 0.035,
      );
      canvas.drawPath(_polygon(center, radius * ring / 3, points), paint);
    }

    paint.color = MockMateColors.outlineStrong.withValues(alpha: 0.6);
    for (var index = 0; index < points; index++) {
      final angle = -math.pi / 2 + index * math.pi * 2 / points;
      canvas.drawLine(
        center,
        Offset(
          center.dx + math.cos(angle) * radius,
          center.dy + math.sin(angle) * radius,
        ),
        paint,
      );
    }
  }

  Path _polygon(Offset center, double radius, int points) {
    final path = Path();
    for (var index = 0; index < points; index++) {
      final angle = -math.pi / 2 + index * math.pi * 2 / points;
      final point = Offset(
        center.dx + math.cos(angle) * radius,
        center.dy + math.sin(angle) * radius,
      );
      index == 0
          ? path.moveTo(point.dx, point.dy)
          : path.lineTo(point.dx, point.dy);
    }
    return path..close();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
