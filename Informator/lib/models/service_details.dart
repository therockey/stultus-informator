import 'package:informator/models/notification_preferences.dart';
import 'package:informator/models/service.dart';

/// Where the status information comes from.
enum OutageSource { official, community }

/// One day of community reports, used by the details chart.
class ReportPoint {
  const ReportPoint({required this.day, required this.count});

  final DateTime day;

  final int count;
}

/// Full card of a service: catalogue row plus the current interruption, if any.
class ServiceDetails {
  const ServiceDetails({
    required this.service,
    required this.notifications,
    this.cause,
    this.windowStart,
    this.windowEnd,
    this.eta,
    this.progress,
    this.source,
    this.isPlanned = false,
    this.officialUrl,
    this.lastChecked,
    this.nearbyReportsLastHour = 0,
    this.localStreets = const <String>[],
    this.allStreets = const <String>[],
    this.reportPoints = const <ReportPoint>[],
    this.distressingNote,
  });

  final Service service;

  final ServiceNotificationSettings notifications;

  final String? cause;

  final DateTime? windowStart;

  final DateTime? windowEnd;

  final DateTime? eta;

  /// Repair progress in percent, 0–100.
  final int? progress;

  final OutageSource? source;

  final bool isPlanned;

  final String? officialUrl;

  final DateTime? lastChecked;

  final int nearbyReportsLastHour;

  final List<String> localStreets;

  final List<String> allStreets;

  final List<ReportPoint> reportPoints;

  /// Extra note that the F8 filter may hide (accidents, mass alerts).
  final String? distressingNote;

  bool get hasOutage => service.status != ServiceStatus.operational;

  ServiceDetails copyWith({ServiceNotificationSettings? notifications}) {
    return ServiceDetails(
      service: service,
      notifications: notifications ?? this.notifications,
      cause: cause,
      windowStart: windowStart,
      windowEnd: windowEnd,
      eta: eta,
      progress: progress,
      source: source,
      isPlanned: isPlanned,
      officialUrl: officialUrl,
      lastChecked: lastChecked,
      nearbyReportsLastHour: nearbyReportsLastHour,
      localStreets: localStreets,
      allStreets: allStreets,
      reportPoints: reportPoints,
      distressingNote: distressingNote,
    );
  }
}
