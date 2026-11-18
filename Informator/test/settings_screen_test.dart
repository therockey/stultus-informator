import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:informator/generated/l10n.dart';
import 'package:informator/providers/shared_preferences_provider.dart';
import 'package:informator/screens/home/settings_screen.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Widget> settingsApp([Map<String, Object> initial = const {}]) async {
  SharedPreferences.setMockInitialValues(initial);
  final prefs = await SharedPreferences.getInstance();

  return ProviderScope(
    overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    child: MaterialApp(
      locale: const Locale('pl'),
      localizationsDelegates: [
        S.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: const Scaffold(body: SettingsScreen()),
    ),
  );
}

Future<void> _scrollTo(WidgetTester tester, Finder finder) async {
  final list = find.byType(ListView);
  for (var i = 0; i < 12; i++) {
    if (finder.evaluate().isNotEmpty) {
      await tester.ensureVisible(finder);
      await tester.pumpAndSettle();
      return;
    }
    await tester.drag(list, const Offset(0, -280));
    await tester.pump();
  }
}

void main() {
  testWidgets('lists accessibility and notification settings', (tester) async {
    await tester.pumpWidget(await settingsApp());
    await tester.pumpAndSettle();

    expect(find.text('Tryb uproszczony'), findsOneWidget);
    expect(find.text('Ukryj treści niepokojące'), findsOneWidget);
    await _scrollTo(tester, find.text('Powiadomienie push'));
    expect(find.text('Powiadomienie push'), findsOneWidget);
    await _scrollTo(tester, find.text('Ciche godziny'));
    expect(find.text('Ciche godziny'), findsOneWidget);
    await _scrollTo(tester, find.text('Otwórz słownik pojęć'));
    expect(find.text('Otwórz słownik pojęć'), findsOneWidget);
  });

  testWidgets('persists simplified mode', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: MaterialApp(
          locale: const Locale('pl'),
          localizationsDelegates: [
            S.delegate,
            ...GlobalMaterialLocalizations.delegates,
          ],
          supportedLocales: S.delegate.supportedLocales,
          home: const Scaffold(body: SettingsScreen()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Tryb uproszczony'));
    await tester.pumpAndSettle();

    expect(prefs.getBool('simplified_mode'), isTrue);
  });

  testWidgets('enabling quiet hours stores a default window', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: MaterialApp(
          locale: const Locale('pl'),
          localizationsDelegates: [
            S.delegate,
            ...GlobalMaterialLocalizations.delegates,
          ],
          supportedLocales: S.delegate.supportedLocales,
          home: const Scaffold(body: SettingsScreen()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await _scrollTo(tester, find.text('Ciche godziny'));
    await tester.tap(find.text('Ciche godziny'));
    await tester.pumpAndSettle();

    expect(prefs.getInt('quiet_hours_start'), 22 * 60);
    expect(prefs.getInt('quiet_hours_end'), 7 * 60);
    expect(find.text('Od'), findsOneWidget);
    expect(find.text('Do'), findsOneWidget);
  });
}
