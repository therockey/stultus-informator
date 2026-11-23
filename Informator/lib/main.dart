import 'dart:io';

import 'package:material_ui/material_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart' as flutter_localizations;
import 'package:informator/theme.dart';
import 'package:informator/generated/l10n.dart';
import 'package:informator/providers/shared_preferences_provider.dart';
import 'package:informator/providers/locale_provider.dart';
import 'package:informator/providers/app_theme_provider.dart';
import 'package:informator/providers/user_settings_provider.dart';
import 'package:informator/screens/error_screen.dart';
import 'package:informator/screens/license_screen.dart';
import 'package:informator/screens/home_screen.dart';
import 'package:informator/screens/intro/intro_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  final prefs = await SharedPreferences.getInstance();

  final container = ProviderContainer(
    overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
  );

  await container.read(themeProvider).loadTheme();

  runApp(UncontrolledProviderScope(container: container, child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  Future<Widget> _getHome(WidgetRef ref) async {
    final prefs = await SharedPreferences.getInstance();
    final firstRun = prefs.getBool("isFirstRun") ?? true;

    try {
      if (firstRun) {
        return const IntroScreen();
      }

      return const HomeScreen();
    } on Exception catch (e) {
      return ErrorScreen(errorText: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final localeNotifier = ref.watch(localeProvider);
    final themeNotifier = ref.watch(themeProvider);
    final userSettings = ref.watch(userSettingsProvider).settings;

    return MaterialApp(
      title: 'Flutter Demo',
      locale: localeNotifier.locale,
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        flutter_localizations.GlobalMaterialLocalizations.delegate,
        flutter_localizations.GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: ThemeData(
        colorScheme: userSettings.highContrast
            ? MaterialTheme.lightMediumContrastScheme()
            : MaterialTheme.lightScheme(),
      ),
      darkTheme: ThemeData(
        colorScheme: userSettings.highContrast
            ? MaterialTheme.darkMediumContrastScheme()
            : MaterialTheme.darkScheme(),
      ),
      themeMode: themeNotifier.themeMode,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(userSettings.textScale),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
      routes: {
        '/home': (context) => const HomeScreen(),
        '/license': (context) => const LicenseScreen(),
        '/error': (context) => const ErrorScreen(),
        '/groups': (context) => const HomeScreen("groups"),
        '/services': (context) => const HomeScreen("services"),
        '/settings': (context) => const HomeScreen("settings"),
      },
      home: FutureBuilder<Widget>(
        future: _getHome(ref),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return snapshot.data!;
          } else {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }
}
