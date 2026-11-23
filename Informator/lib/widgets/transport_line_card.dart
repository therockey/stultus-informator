import 'package:informator/generated/l10n.dart';
import 'package:informator/models/transport.dart';
import 'package:informator/widgets/service_status.dart';
import 'package:informator/widgets/transport_delay_chart.dart';
import 'package:material_ui/material_ui.dart';

/// One line on the transport screen: status indicator, name, kind and status,
/// plus a delay sparkline. The whole card opens the line's details.
class TransportLineCard extends StatelessWidget {
  const TransportLineCard({super.key, required this.line, this.onOpen});

  final TransportLine line;

  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final strings = S.of(context);
    final color = kServiceStatusColors[line.status]!;
    final currentDelay = line.delays.isEmpty ? null : line.delays.last.minutes;

    return Material(
      color: theme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              ServiceStatusBadge(status: line.status),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      line.name,
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
                      '${transportKindLabel(strings, line.kind)} · '
                      '${serviceStatusLabel(strings, line.status)}',
                      style: TextStyle(
                        color: theme.onSurface,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TransportDelaySparkline(points: line.delays, color: color),
                  if (currentDelay != null)
                    Text(
                      strings.transport_delay_minutes(currentDelay),
                      style: TextStyle(
                        color: theme.onSurfaceVariant,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
              Icon(Icons.chevron_right, color: theme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}

String transportKindLabel(S strings, TransportKind kind) {
  return switch (kind) {
    TransportKind.tram => strings.transport_kind_tram,
    TransportKind.bus => strings.transport_kind_bus,
  };
}
