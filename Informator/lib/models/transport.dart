import 'package:informator/models/service.dart';
import 'package:informator/models/service_details.dart';

enum TransportKind { tram, bus }

/// A point of a line's schematic route, normalised to the 0..1 range.
class TransportRoutePoint {
  const TransportRoutePoint({required this.x, required this.y});

  final double x;

  final double y;
}

/// Delay of a line measured at a given hour; used by the delay charts.
class TransportDelayPoint {
  const TransportDelayPoint({required this.time, required this.minutes});

  final DateTime time;

  final int minutes;
}

/// A public transport line shown on the transport screen.
class TransportLine {
  const TransportLine({
    required this.id,
    required this.name,
    required this.shortName,
    required this.kind,
    required this.status,
    this.route = const <TransportRoutePoint>[],
    this.delays = const <TransportDelayPoint>[],
    this.disruptedFrom,
    this.disruptedTo,
  });

  final String id;

  /// Full display name, e.g. "Linia 12".
  final String name;

  /// Label drawn on the map, e.g. "12".
  final String shortName;

  final TransportKind kind;

  final ServiceStatus status;

  final List<TransportRoutePoint> route;

  final List<TransportDelayPoint> delays;

  /// Indices (inclusive) of the route points bounding the disrupted segment.
  final int? disruptedFrom;

  final int? disruptedTo;

  bool get hasOutage => status != ServiceStatus.operational;
}

/// "Take [fromLine], then change to [toLine]".
class TransportDetour {
  const TransportDetour({required this.fromLine, required this.toLine});

  final String fromLine;

  final String toLine;
}

/// Full card of a line: the line itself plus the current disruption, if any.
class TransportLineDetails {
  const TransportLineDetails({
    required this.line,
    this.cause,
    this.startedAt,
    this.eta,
    this.source,
    this.lastChecked,
    this.areaX,
    this.areaY,
    this.areaRadius,
    this.detours = const <TransportDetour>[],
  });

  final TransportLine line;

  final String? cause;

  final DateTime? startedAt;

  final DateTime? eta;

  final OutageSource? source;

  final DateTime? lastChecked;

  /// Centre and radius of the affected area, normalised to the 0..1 range.
  final double? areaX;

  final double? areaY;

  final double? areaRadius;

  final List<TransportDetour> detours;

  bool get hasArea => areaX != null && areaY != null && areaRadius != null;
}
