/// A named set of services the user observes together, optionally pinned to
/// one location.
class Group {
  const Group({
    required this.id,
    required this.name,
    this.location,
    this.notificationsEnabled = false,
  });

  final String id;

  final String name;

  /// Address the group is assigned to; `null` when the group has none.
  final String? location;

  /// Whether outage notifications for this group are turned on.
  final bool notificationsEnabled;

  Group copyWith({bool? notificationsEnabled}) {
    return Group(
      id: id,
      name: name,
      location: location,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}
