import 'package:material_ui/material_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:informator/theme.dart';
import 'package:informator/generated/l10n.dart';
import 'package:informator/providers/shared_preferences_provider.dart';
import 'package:informator/providers/locale_provider.dart';
import 'package:informator/screens/error_screen.dart';
import 'package:informator/screens/license_screen.dart';

void main() async {
  final prefs = await SharedPreferences.getInstance();

  final container = ProviderContainer(
    overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
  );

  WidgetsFlutterBinding.ensureInitialized();
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

    return MaterialApp(
      title: 'Flutter Demo',
      locale: localeNotifier.locale,
      localizationsDelegates: [
        S.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: ThemeData(colorScheme: MaterialTheme.darkScheme()),
        routes: {
          '/home': (context) => const HomeScreen(),
          '/pairing': (context) => PairingScreen(),
          '/about': (context) => const AboutScreen(),
          '/license': (context) => const LicenseScreen(),
          '/error': (context) => const ErrorScreen(),
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
      )
    );
  }
}
