import 'package:informator/models/notification_preferences.dart';

/// Global preferences from the settings tab (F3 channel / quiet hours, F8).
class UserSettings {
  const UserSettings({
    this.simplifiedMode = false,
    this.textScale = 1.0,
    this.highContrast = false,
    this.hideDistressing = true,
    this.channel = NotificationChannel.push,
    this.quietHoursStart,
    this.quietHoursEnd,
  });

  final bool simplifiedMode;

  /// Linear text scaler applied in [MediaQuery], 1.0–1.3.
  final double textScale;

  final bool highContrast;

  /// F8 filter of accidents and mass alerts; on by default.
  final bool hideDistressing;

  final NotificationChannel channel;

  /// Minutes from midnight; `null` means quiet hours are off.
  final int? quietHoursStart;

  final int? quietHoursEnd;

  bool get quietHoursEnabled =>
      quietHoursStart != null && quietHoursEnd != null;

  UserSettings copyWith({
    bool? simplifiedMode,
    double? textScale,
    bool? highContrast,
    bool? hideDistressing,
    NotificationChannel? channel,
    int? quietHoursStart,
    int? quietHoursEnd,
    bool clearQuietHours = false,
  }) {
    return UserSettings(
      simplifiedMode: simplifiedMode ?? this.simplifiedMode,
      textScale: textScale ?? this.textScale,
      highContrast: highContrast ?? this.highContrast,
      hideDistressing: hideDistressing ?? this.hideDistressing,
      channel: channel ?? this.channel,
      quietHoursStart: clearQuietHours
          ? null
          : quietHoursStart ?? this.quietHoursStart,
      quietHoursEnd: clearQuietHours
          ? null
          : quietHoursEnd ?? this.quietHoursEnd,
    );
  }
}
