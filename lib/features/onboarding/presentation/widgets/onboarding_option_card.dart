import 'package:flutter/material.dart';
import 'package:mockmate/core/theme/mockmate_theme.dart';

class OnboardingOptionCard extends StatelessWidget {
  const OnboardingOptionCard({
    required this.title,
    required this.selected,
    required this.onTap,
    this.subtitle,
    this.icon,
    this.dense = false,
    super.key,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final bool selected;
  final bool dense;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final duration = reduceMotion
        ? Duration.zero
        : const Duration(milliseconds: 160);

    return Semantics(
      button: true,
      selected: selected,
      label: subtitle == null ? title : '$title. $subtitle',
      child: AnimatedContainer(
        duration: duration,
        curve: Curves.easeOutCubic,
        constraints: BoxConstraints(minHeight: dense ? 62 : 76),
        decoration: BoxDecoration(
          color: selected
              ? MockMateColors.primary.withValues(alpha: 0.13)
              : MockMateColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? MockMateColors.primary.withValues(alpha: 0.85)
                : MockMateColors.outline,
            width: selected ? 1.4 : 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            canRequestFocus: true,
            focusColor: MockMateColors.primary.withValues(alpha: 0.12),
            hoverColor: MockMateColors.surfaceRaised.withValues(alpha: 0.7),
            overlayColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.pressed)) {
                return MockMateColors.primary.withValues(alpha: 0.14);
              }
              return null;
            }),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: dense ? 14 : MockMateSpacing.medium,
                vertical: dense ? 12 : 14,
              ),
              child: Row(
                children: [
                  if (icon != null) ...[
                    AnimatedContainer(
                      duration: duration,
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: selected
                            ? MockMateColors.primary.withValues(alpha: 0.2)
                            : MockMateColors.surfaceRaised,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        icon,
                        size: 20,
                        color: selected
                            ? MockMateColors.textPrimary
                            : MockMateColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: MockMateSpacing.small),
                  ],
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: selected
                                    ? MockMateColors.textPrimary
                                    : MockMateColors.textPrimary.withValues(
                                        alpha: 0.9,
                                      ),
                                fontSize: dense ? 14 : 15,
                              ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            subtitle!,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(fontSize: 12, height: 1.35),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: MockMateSpacing.xSmall),
                  AnimatedContainer(
                    duration: duration,
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: selected
                          ? MockMateColors.primary
                          : Colors.transparent,
                      border: Border.all(
                        color: selected
                            ? MockMateColors.primary
                            : MockMateColors.outlineStrong,
                      ),
                    ),
                    child: selected
                        ? const Icon(
                            Icons.check_rounded,
                            size: 15,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
