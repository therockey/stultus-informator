import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:informator/generated/l10n.dart';

final localeProvider = ChangeNotifierProvider<LocaleNotifier>((ref) {
  final notifier = LocaleNotifier();
  notifier.loadLocale();
  return notifier;
});

class LocaleNotifier extends ChangeNotifier {
  Locale? _locale;

  Locale? get locale => _locale;

  static const _key = "app_locale";

  Future<void> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_key);

    if (code != null && code.isNotEmpty) {
      _locale = Locale(code);
    } else {
      _locale = getSystemDefaultOrFallbackLocale();
    }

    notifyListeners();
  }

  Future<void> setLocale(Locale? locale) async {
    final prefs = await SharedPreferences.getInstance();

    if (locale == null) {
      await prefs.remove(_key);
      _locale = getSystemDefaultOrFallbackLocale();
    } else {
      if(!S.delegate.supportedLocales.contains(locale)) {
        return;
      }
      await prefs.setString(_key, locale.languageCode);
      _locale = locale;
    }

    notifyListeners();
  }

  Locale getSystemDefaultOrFallbackLocale() {
    final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;
    final supportedLocales = S.delegate.supportedLocales;

    final matchesSupported = supportedLocales
        .any((loc) => loc.languageCode == systemLocale.languageCode);

    if (matchesSupported) {
      return supportedLocales.firstWhere(
          (loc) => loc.languageCode == systemLocale.languageCode);
    } else {
      return const Locale('en');
    }
  }
}
