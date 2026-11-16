import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:material_ui/material_ui.dart';
import 'package:native_lens/native_lens.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode { light, dark, system }

final themeProvider = ChangeNotifierProvider<ThemeNotifier>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends ChangeNotifier with WidgetsBindingObserver {
  static const _key = 'app_theme';

  AppThemeMode _theme = AppThemeMode.system;
  NativeLensThemeMode _systemTheme = NativeLensThemeMode.unknown;
  StreamSubscription<NativeLensThemeMode>? _themeSubscription;

  AppThemeMode get theme => _theme;

  ThemeMode get themeMode {
    return switch (_theme) {
      AppThemeMode.light => ThemeMode.light,
      AppThemeMode.dark => ThemeMode.dark,
      AppThemeMode.system =>
        _systemTheme == NativeLensThemeMode.dark
            ? ThemeMode.dark
            : ThemeMode.light,
    };
  }

  ThemeNotifier() {
    WidgetsBinding.instance.addObserver(this);
    _systemTheme = _brightnessToNative(
      WidgetsBinding.instance.platformDispatcher.platformBrightness,
    );
    _subscribeToSystemTheme();
  }

  @override
  void didChangePlatformBrightness() {
    if (_theme != AppThemeMode.system) return;

    _systemTheme = _brightnessToNative(
      WidgetsBinding.instance.platformDispatcher.platformBrightness,
    );
    notifyListeners();
  }

  Future<void> loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final name = prefs.getString(_key);

      _theme = AppThemeMode.values.firstWhere(
        (mode) => mode.name == name,
        orElse: () => AppThemeMode.system,
      );
    } catch (_) {
      _theme = AppThemeMode.system;
    }

    _subscribeToSystemTheme();
    notifyListeners();
  }

  Future<void> setTheme(AppThemeMode? theme) async {
    final prefs = await SharedPreferences.getInstance();

    if (theme == null) {
      await prefs.remove(_key);
      _theme = AppThemeMode.system;
    } else {
      await prefs.setString(_key, theme.name);
      _theme = theme;
    }

    _subscribeToSystemTheme();
    notifyListeners();
  }

  void _subscribeToSystemTheme() {
    _themeSubscription?.cancel();
    _themeSubscription = null;

    if (_theme != AppThemeMode.system) return;

    _systemTheme = _brightnessToNative(
      WidgetsBinding.instance.platformDispatcher.platformBrightness,
    );

    if (defaultTargetPlatform != TargetPlatform.android &&
        defaultTargetPlatform != TargetPlatform.iOS) {
      return;
    }

    try {
      _themeSubscription = NativeLens().watchThemeMode().listen(
        (themeMode) {
          if (themeMode == NativeLensThemeMode.unknown) return;

          _systemTheme = themeMode;
          if (_theme == AppThemeMode.system) notifyListeners();
        },
        onError: (Object error, StackTrace stackTrace) {
          // Keep the platform brightness fallback when NativeLens is unavailable.
        },
      );
    } catch (_) {
      // NativeLens is only available on mobile; the fallback remains in place.
    }
  }

  static NativeLensThemeMode _brightnessToNative(Brightness brightness) {
    return brightness == Brightness.dark
        ? NativeLensThemeMode.dark
        : NativeLensThemeMode.light;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _themeSubscription?.cancel();
    super.dispose();
  }
}
