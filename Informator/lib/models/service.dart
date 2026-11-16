/// Availability state of a service, signalled on the services list by the
/// colour of its status indicator.
enum ServiceStatus {
  /// The service works as expected.
  operational,

  /// The service is unavailable in a part of its area only.
  degraded,

  /// The service is unavailable.
  outage,
}

/// A service the user can look up and observe.
class Service {
  const Service({
    required this.id,
    required this.name,
    required this.status,
    this.groups = const <String>[],
  });

  final String id;

  final String name;

  final ServiceStatus status;

  /// Names of the groups the service belongs to, in display order.
  final List<String> groups;

  bool matchesQuery(String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) {
      return true;
    }

    return name.toLowerCase().contains(normalized);
  }
}
