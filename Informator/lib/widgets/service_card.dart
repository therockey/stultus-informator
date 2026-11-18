import 'package:informator/generated/l10n.dart';
import 'package:informator/models/service.dart';
import 'package:informator/widgets/service_status.dart';
import 'package:material_ui/material_ui.dart';

/// Single service on the services list: status indicator, name, the groups it
/// belongs to and the actions available for it.
class ServiceCard extends StatelessWidget {
  const ServiceCard({
    super.key,
    required this.service,
    this.onOpen,
    this.onReportOutage,
    this.onAddToGroup,
  });

  final Service service;

  /// Opens the details screen. The whole block is the hit target (F2).
  final VoidCallback? onOpen;

  final VoidCallback? onReportOutage;
  final VoidCallback? onAddToGroup;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final strings = S.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onOpen,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ServiceStatusBadge(status: service.status),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              service.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: theme.onSurfaceVariant,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.4,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              serviceStatusLabel(strings, service.status),
                              style: TextStyle(
                                color: theme.onSurface,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (service.groups.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  for (final group in service.groups)
                                    _GroupChip(label: group),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // The buttons share one width so the column reads as a single block,
          // regardless of how long each translated label is.
          IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ServiceActionButton(
                  icon: Icons.warning_amber_rounded,
                  label: strings.service_report_outage,
                  onPressed: onReportOutage,
                ),
                if (onAddToGroup != null) ...[
                  const SizedBox(height: 8),
                  ServiceActionButton(
                    icon: Icons.home_outlined,
                    label: strings.service_add_to_group,
                    onPressed: onAddToGroup,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact secondary action used inside a [ServiceCard].
class ServiceActionButton extends StatelessWidget {
  const ServiceActionButton({
    super.key,
    required this.icon,
    required this.label,
    this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Material(
      color: theme.secondary,
      borderRadius: BorderRadius.circular(4),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: theme.onSecondary),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  color: theme.onSecondary,
                  fontSize: 11,
                  height: 1,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GroupChip extends StatelessWidget {
  const _GroupChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = _groupColors(Theme.of(context).colorScheme, label);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: colors.foreground,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          height: 20 / 14,
          letterSpacing: 0.1,
        ),
      ),
    );
  }

  /// The same group always gets the same chip colour, whichever service it is
  /// listed under.
  static ({Color background, Color foreground}) _groupColors(
    ColorScheme scheme,
    String group,
  ) {
    final palette = <({Color background, Color foreground})>[
      (background: scheme.primaryFixed, foreground: scheme.onPrimaryFixed),
      (
        background: scheme.primaryFixedDim,
        foreground: scheme.onPrimaryFixedVariant,
      ),
      (background: scheme.tertiaryFixed, foreground: scheme.onTertiaryFixed),
      (
        background: scheme.tertiaryFixedDim,
        foreground: scheme.onTertiaryFixedVariant,
      ),
    ];

    final index =
        group.codeUnits.fold<int>(0, (sum, unit) => sum + unit) %
        palette.length;

    return palette[index];
  }
}
