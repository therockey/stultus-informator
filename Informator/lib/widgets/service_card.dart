import 'package:informator/generated/l10n.dart';
import 'package:informator/models/service.dart';
import 'package:material_ui/material_ui.dart';

/// Status colours taken from the "ICK Informator" design; they are not part of
/// the Material colour scheme because they encode availability, not a role.
const Map<ServiceStatus, Color> _statusColors = <ServiceStatus, Color>{
  ServiceStatus.operational: Color(0xFF37D955),
  ServiceStatus.degraded: Color(0xFFD9BE37),
  ServiceStatus.outage: Color(0xFFD93737),
};

const Color _statusGlyphColor = Color(0xFF1E1E1E);

/// Single service on the services list: status indicator, name, the groups it
/// belongs to and the actions available for it.
class ServiceCard extends StatelessWidget {
  const ServiceCard({
    super.key,
    required this.service,
    this.onReportOutage,
    this.onAddToGroup,
  });

  final Service service;

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
          _StatusIndicator(status: service.status),
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
                const SizedBox(height: 8),
                ServiceActionButton(
                  icon: Icons.home_outlined,
                  label: strings.service_add_to_group,
                  onPressed: onAddToGroup,
                ),
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

class _StatusIndicator extends StatelessWidget {
  const _StatusIndicator({required this.status});

  final ServiceStatus status;

  @override
  Widget build(BuildContext context) {
    final color = _statusColors[status]!;

    return Semantics(
      label: _statusLabel(context, status),
      child: ExcludeSemantics(
        child: Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: _statusGlyphColor, width: 2),
          ),
          child: const Text(
            'i',
            style: TextStyle(
              color: _statusGlyphColor,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }

  static String _statusLabel(BuildContext context, ServiceStatus status) {
    final strings = S.of(context);

    return switch (status) {
      ServiceStatus.operational => strings.service_status_operational,
      ServiceStatus.degraded => strings.service_status_degraded,
      ServiceStatus.outage => strings.service_status_outage,
    };
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
    final index = group.codeUnits.fold<int>(0, (sum, unit) => sum + unit) %
        palette.length;

    return palette[index];
  }
}
