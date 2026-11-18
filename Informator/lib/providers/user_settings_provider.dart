import 'package:hooks_riverpod/legacy.dart';
import 'package:informator/models/notification_preferences.dart';
import 'package:informator/models/user_settings.dart';
import 'package:informator/providers/shared_preferences_provider.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

final userSettingsProvider = ChangeNotifierProvider<UserSettingsNotifier>((
  ref,
) {
  return UserSettingsNotifier(ref.watch(sharedPreferencesProvider));
});

class UserSettingsNotifier extends ChangeNotifier {
  UserSettingsNotifier(this._prefs) {
    _settings = _read();
  }

  static const _simplifiedKey = 'simplified_mode';
  static const _textScaleKey = 'text_scale';
  static const _highContrastKey = 'high_contrast';
  static const _hideDistressingKey = 'hide_distressing';
  static const _channelKey = 'notify_channel';
  static const _quietStartKey = 'quiet_hours_start';
  static const _quietEndKey = 'quiet_hours_end';

  static const textScaleOptions = <double>[1.0, 1.15, 1.3];

  final SharedPreferences _prefs;

  late UserSettings _settings;

  UserSettings get settings => _settings;

  UserSettings _read() {
    final storedScale = _prefs.getDouble(_textScaleKey) ?? 1.0;
    final scale = textScaleOptions.contains(storedScale) ? storedScale : 1.0;
    final channelName = _prefs.getString(_channelKey);
    final channel = NotificationChannel.values.firstWhere(
      (item) => item.name == channelName,
      orElse: () => NotificationChannel.push,
    );

    return UserSettings(
      simplifiedMode: _prefs.getBool(_simplifiedKey) ?? false,
      textScale: scale,
      highContrast: _prefs.getBool(_highContrastKey) ?? false,
      hideDistressing: _prefs.getBool(_hideDistressingKey) ?? true,
      channel: channel,
      quietHoursStart: _prefs.getInt(_quietStartKey),
      quietHoursEnd: _prefs.getInt(_quietEndKey),
    );
  }

  Future<void> setSimplifiedMode(bool value) {
    return _commit(_settings.copyWith(simplifiedMode: value));
  }

  Future<void> setTextScale(double value) {
    return _commit(_settings.copyWith(textScale: value));
  }

  Future<void> setHighContrast(bool value) {
    return _commit(_settings.copyWith(highContrast: value));
  }

  Future<void> setHideDistressing(bool value) {
    return _commit(_settings.copyWith(hideDistressing: value));
  }

  Future<void> setChannel(NotificationChannel value) {
    return _commit(_settings.copyWith(channel: value));
  }

  Future<void> setQuietHours({required int startMinutes, required int endMinutes}) {
    return _commit(
      _settings.copyWith(
        quietHoursStart: startMinutes,
        quietHoursEnd: endMinutes,
      ),
    );
  }

  Future<void> clearQuietHours() {
    return _commit(_settings.copyWith(clearQuietHours: true));
  }

  Future<void> _commit(UserSettings next) async {
    _settings = next;
    await _prefs.setBool(_simplifiedKey, next.simplifiedMode);
    await _prefs.setDouble(_textScaleKey, next.textScale);
    await _prefs.setBool(_highContrastKey, next.highContrast);
    await _prefs.setBool(_hideDistressingKey, next.hideDistressing);
    await _prefs.setString(_channelKey, next.channel.name);
    if (next.quietHoursStart == null || next.quietHoursEnd == null) {
      await _prefs.remove(_quietStartKey);
      await _prefs.remove(_quietEndKey);
    } else {
      await _prefs.setInt(_quietStartKey, next.quietHoursStart!);
      await _prefs.setInt(_quietEndKey, next.quietHoursEnd!);
    }
    notifyListeners();
  }
}
