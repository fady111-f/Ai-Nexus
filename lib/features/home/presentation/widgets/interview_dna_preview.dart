import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:mockmate/core/routing/app_routes.dart';
import 'package:mockmate/core/theme/mockmate_theme.dart';

class DnaMetric {
  const DnaMetric({
    required this.name,
    required this.score,
    required this.icon,
  });
  final String name;
  final int score;
  final IconData icon;
}

class InterviewDnaPreview extends StatelessWidget {
  const InterviewDnaPreview({required this.hasSessions, super.key});

  final bool hasSessions;

  static const List<DnaMetric> _coreMetrics = [
    DnaMetric(name: 'Technical Depth', score: 78, icon: Icons.code_rounded),
    DnaMetric(
      name: 'Clarity',
      score: 82,
      icon: Icons.record_voice_over_rounded,
    ),
    DnaMetric(name: 'Conciseness', score: 70, icon: Icons.compress_rounded),
    DnaMetric(
      name: 'Confidence Signals',
      score: 85,
      icon: Icons.psychology_rounded,
    ),
    DnaMetric(
      name: 'Evidence-Based Answers',
      score: 75,
      icon: Icons.verified_rounded,
    ),
    DnaMetric(
      name: 'Adaptability',
      score: 80,
      icon: Icons.auto_awesome_rounded,
    ),
  ];

  static const List<String> _levels = [
    'Rookie',
    'Prepared',
    'Strong Candidate',
    'Interview Ready',
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
                'Interview DNA & Skill Radar',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.of(context).pushNamed(AppRoutes.progress),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: MockMateColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(99),
                  border: Border.all(
                    color: MockMateColors.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 14,
                      color: MockMateColors.primary,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Full DNA Report',
                      style: TextStyle(
                        color: MockMateColors.primary,
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
          key: const Key('interviewDnaActiveCard'),
          decoration: BoxDecoration(
            color: MockMateColors.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: MockMateColors.outline),
          ),
          child: Padding(
            padding: const EdgeInsets.all(MockMateSpacing.large),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Experience Design Panel Header
                LayoutBuilder(
                  builder: (context, constraints) {
                    final wide = constraints.maxWidth >= 600;
                    return wide
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox.square(
                                dimension: 180,
                                child: CustomPaint(
                                  painter: _RadarChartPainter(
                                    metrics: _coreMetrics,
                                  ),
                                ),
                              ),
                              const SizedBox(width: MockMateSpacing.large),
                              Expanded(child: _buildDnaSummaryCopy(context)),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                child: SizedBox.square(
                                  dimension: 170,
                                  child: CustomPaint(
                                    painter: _RadarChartPainter(
                                      metrics: _coreMetrics,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: MockMateSpacing.large),
                              _buildDnaSummaryCopy(context),
                            ],
                          );
                  },
                ),
                const SizedBox(height: MockMateSpacing.large),

                // Gamified Levels Tracker
                const Text(
                  'Progression Level',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: MockMateColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                _buildGamifiedLevelsTracker(context),

                const SizedBox(height: MockMateSpacing.large),
                const Divider(color: MockMateColors.outline),
                const SizedBox(height: MockMateSpacing.medium),

                // Core Metrics Panel
                Text(
                  'Core Metrics Breakdown',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: MockMateSpacing.medium),
                _buildCoreMetricsList(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDnaSummaryCopy(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: MockMateColors.cyan.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: MockMateColors.cyan.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.trending_up_rounded,
                      color: MockMateColors.cyan,
                      size: 14,
                    ),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        'Growth over time: 62 → 78 (+16 pts)',
                        style: const TextStyle(
                          color: MockMateColors.cyan,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          'Active Candidate Profile',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          'Based on evaluation across technical clarity, depth, and adaptability.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12),
        ),
        const SizedBox(height: 12),

        _buildInsightPill(
          icon: Icons.star_rounded,
          iconColor: Colors.amberAccent,
          label: 'Strongest Trait:',
          value: 'Confidence Signals (85/100)',
        ),
        const SizedBox(height: 6),
        _buildInsightPill(
          icon: Icons.lightbulb_outline_rounded,
          iconColor: MockMateColors.cyan,
          label: 'Biggest Opportunity:',
          value: 'Conciseness (70/100)',
        ),
      ],
    );
  }

  Widget _buildInsightPill({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: MockMateColors.surfaceRaised,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: MockMateColors.outlineStrong),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 16),
          const SizedBox(width: 6),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '$label ',
                    style: const TextStyle(
                      color: MockMateColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  TextSpan(
                    text: value,
                    style: const TextStyle(
                      color: MockMateColors.textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGamifiedLevelsTracker(BuildContext context) {
    const activeIndex = 2; // "Strong Candidate" active
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          children: List.generate(_levels.length, (index) {
            final isCompleted = index <= activeIndex;
            final isActive = index == activeIndex;
            return Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                decoration: BoxDecoration(
                  color: isActive
                      ? MockMateColors.primary.withValues(alpha: 0.25)
                      : isCompleted
                      ? MockMateColors.surfaceRaised
                      : MockMateColors.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isActive
                        ? MockMateColors.primary
                        : isCompleted
                        ? MockMateColors.outlineStrong
                        : MockMateColors.outline,
                    width: isActive ? 1.5 : 1,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      isActive
                          ? Icons.workspace_premium_rounded
                          : isCompleted
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_unchecked_rounded,
                      size: 16,
                      color: isActive
                          ? MockMateColors.primary
                          : isCompleted
                          ? MockMateColors.cyan
                          : MockMateColors.textSecondary,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _levels[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isActive
                            ? Colors.white
                            : isCompleted
                            ? MockMateColors.textPrimary
                            : MockMateColors.textSecondary,
                        fontSize: 10,
                        fontWeight: isActive
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildCoreMetricsList() {
    return Column(
      children: _coreMetrics.map((m) {
        final double factor = m.score / 100.0;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              Icon(m.icon, size: 16, color: MockMateColors.cyan),
              const SizedBox(width: 10),
              SizedBox(
                width: 140,
                child: Text(
                  m.name,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: factor,
                    minHeight: 8,
                    backgroundColor: MockMateColors.surfaceRaised,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color.lerp(
                        MockMateColors.primary,
                        MockMateColors.cyan,
                        factor,
                      )!,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${m.score}/100',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: MockMateColors.textPrimary,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _RadarChartPainter extends CustomPainter {
  _RadarChartPainter({required this.metrics});

  final List<DnaMetric> metrics;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide * 0.42;
    final count = metrics.length;
    if (count == 0) return;

    // Grid web rings
    final gridPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = MockMateColors.outlineStrong.withValues(alpha: 0.4);

    for (var level = 1; level <= 4; level++) {
      final r = radius * (level / 4);
      final path = Path();
      for (var i = 0; i < count; i++) {
        final angle = -math.pi / 2 + (i * 2 * math.pi / count);
        final x = center.dx + math.cos(angle) * r;
        final y = center.dy + math.sin(angle) * r;
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();
      canvas.drawPath(path, gridPaint);
    }

    // Metric axes
    final axisPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = MockMateColors.outlineStrong.withValues(alpha: 0.3);

    for (var i = 0; i < count; i++) {
      final angle = -math.pi / 2 + (i * 2 * math.pi / count);
      final x = center.dx + math.cos(angle) * radius;
      final y = center.dy + math.sin(angle) * radius;
      canvas.drawLine(center, Offset(x, y), axisPaint);
    }

    // Radar values polygon
    final polygonPath = Path();
    final points = <Offset>[];

    for (var i = 0; i < count; i++) {
      final angle = -math.pi / 2 + (i * 2 * math.pi / count);
      final scoreFactor = (metrics[i].score / 100.0).clamp(0.1, 1.0);
      final r = radius * scoreFactor;
      final point = Offset(
        center.dx + math.cos(angle) * r,
        center.dy + math.sin(angle) * r,
      );
      points.add(point);
      if (i == 0) {
        polygonPath.moveTo(point.dx, point.dy);
      } else {
        polygonPath.lineTo(point.dx, point.dy);
      }
    }
    polygonPath.close();

    // Fill radar polygon with gradient
    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = RadialGradient(
        colors: [
          MockMateColors.cyan.withValues(alpha: 0.45),
          MockMateColors.primary.withValues(alpha: 0.25),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawPath(polygonPath, fillPaint);

    // Stroke radar polygon outline
    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = MockMateColors.cyan;

    canvas.drawPath(polygonPath, strokePaint);

    // Vertex dots
    final dotPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white;

    final dotGlow = Paint()
      ..style = PaintingStyle.fill
      ..color = MockMateColors.cyan;

    for (final pt in points) {
      canvas.drawCircle(pt, 4, dotGlow);
      canvas.drawCircle(pt, 2, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RadarChartPainter oldDelegate) => true;
}
