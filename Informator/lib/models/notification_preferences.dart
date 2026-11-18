/// Per-service rule that decides which outages produce an alert.
enum NotificationRule {
  /// Every outage and planned interruption.
  all,

  /// Planned interruptions only (CU-05).
  plannedOnly,

  /// Unplanned outages only.
  outagesOnly,
}

/// How far in advance a planned interruption should be announced.
enum NotificationLeadTime {
  none,
  twoHours,
  oneDay,
}

/// Channel used for alerts. Persistence only — the prototype does not send.
enum NotificationChannel { push, sms }

/// Notification preferences stored for one service.
class ServiceNotificationSettings {
  const ServiceNotificationSettings({
    this.enabled = false,
    this.rule = NotificationRule.all,
    this.leadTime = NotificationLeadTime.none,
  });

  final bool enabled;

  final NotificationRule rule;

  final NotificationLeadTime leadTime;

  ServiceNotificationSettings copyWith({
    bool? enabled,
    NotificationRule? rule,
    NotificationLeadTime? leadTime,
  }) {
    return ServiceNotificationSettings(
      enabled: enabled ?? this.enabled,
      rule: rule ?? this.rule,
      leadTime: leadTime ?? this.leadTime,
    );
  }
}
