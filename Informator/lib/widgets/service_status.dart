import 'package:informator/generated/l10n.dart';
import 'package:informator/models/service.dart';
import 'package:material_ui/material_ui.dart';

/// Status colours taken from the "ICK Informator" design; they are not part of
/// the Material colour scheme because they encode availability, not a role.
const Map<ServiceStatus, Color> kServiceStatusColors = <ServiceStatus, Color>{
  ServiceStatus.operational: Color(0xFF37D955),
  ServiceStatus.degraded: Color(0xFFD9BE37),
  ServiceStatus.outage: Color(0xFFD93737),
};

const Color kServiceStatusGlyphColor = Color(0xFF1E1E1E);

String serviceStatusLabel(S strings, ServiceStatus status) {
  return switch (status) {
    ServiceStatus.operational => strings.service_status_operational,
    ServiceStatus.degraded => strings.service_status_degraded,
    ServiceStatus.outage => strings.service_status_outage,
  };
}

/// Circle plus optional text so status is readable without relying on colour.
class ServiceStatusBadge extends StatelessWidget {
  const ServiceStatusBadge({
    super.key,
    required this.status,
    this.showLabel = false,
    this.size = 32,
  });

  final ServiceStatus status;

  final bool showLabel;

  final double size;

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final label = serviceStatusLabel(strings, status);
    final color = kServiceStatusColors[status]!;

    final indicator = Semantics(
      label: label,
      child: ExcludeSemantics(
        child: Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: kServiceStatusGlyphColor, width: 2),
          ),
          child: Text(
            'i',
            style: TextStyle(
              color: kServiceStatusGlyphColor,
              fontSize: size * 0.625,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
        ),
      ),
    );

    if (!showLabel) {
      return indicator;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        indicator,
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
