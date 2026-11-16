import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:informator/generated/l10n.dart';
import 'package:informator/models/group.dart';
import 'package:informator/providers/groups_provider.dart';
import 'package:informator/screens/home/groups_screen.dart';
import 'package:informator/screens/home_screen.dart';
import 'package:informator/theme.dart';
import 'package:informator/widgets/group_card.dart';
import 'package:material_ui/material_ui.dart';

const Color notificationsOnColor = Color(0xFFCBA600);

class TestGroupsNotifier extends GroupsNotifier {
  @override
  Future<List<Group>> build() async => [
    const Group(id: 'moja-grupa', name: 'Twoja Grupa'),
    const Group(
      id: 'dom',
      name: 'Dom',
      location: 'Szarych Szeregów 2, Kalisz',
      notificationsEnabled: true,
    ),
    const Group(
      id: 'politechnika',
      name: 'Politechnika',
      location: 'Grunwaldzka 15, Wrocław',
      notificationsEnabled: true,
    ),
  ];

  @override
  Future<void> setNotificationsEnabled(String groupId, bool enabled) async {
    state = AsyncData([
      for (final group in state.requireValue)
        group.id == groupId
            ? group.copyWith(notificationsEnabled: enabled)
            : group,
    ]);
  }

  @override
  Future<void> remove(String groupId) async {
    state = AsyncData([
      for (final group in state.requireValue)
        if (group.id != groupId) group,
    ]);
  }
}

Widget localizedApp(Widget child) {
  return ProviderScope(
    overrides: [
      groupsProvider.overrideWith(TestGroupsNotifier.new),
    ],
    child: MaterialApp(
      locale: const Locale('pl'),
      localizationsDelegates: [
        S.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: ThemeData(colorScheme: MaterialTheme.darkScheme()),
      home: Scaffold(body: child),
    ),
  );
}

Future<void> pumpDatabase(WidgetTester tester) async {
  await tester.pump();
  await tester.runAsync(() => Future<void>.delayed(const Duration(seconds: 3)));
  await tester.pump();
}

Finder cardOf(String id) => find.byKey(ValueKey(id));

Finder switchOf(String id) => find.descendant(
  of: cardOf(id),
  matching: find.byType(Switch),
);

Finder bellOf(String id) => find.descendant(
  of: cardOf(id),
  matching: find.byIcon(Icons.notifications_none),
);

Color bellColor(WidgetTester tester, String id) =>
    tester.widget<Icon>(bellOf(id)).color!;

void main() {
  testWidgets('lists the user groups with their locations', (tester) async {
    await tester.pumpWidget(localizedApp(const GroupsScreen()));
    await pumpDatabase(tester);

    expect(find.byType(GroupCard), findsNWidgets(3));
    expect(find.text('Twoja Grupa'), findsOneWidget);
    expect(find.text('Dom'), findsOneWidget);
    expect(find.text('Politechnika'), findsOneWidget);
    expect(find.text('Lokalizacja: Brak'), findsOneWidget);
    expect(find.text('Lokalizacja: Szarych Szeregów 2, Kalisz'), findsOneWidget);
  });

  testWidgets('bell is yellow only where notifications are on', (tester) async {
    await tester.pumpWidget(localizedApp(const GroupsScreen()));
    await pumpDatabase(tester);

    expect(tester.widget<Switch>(switchOf('moja-grupa')).value, isFalse);
    expect(bellColor(tester, 'moja-grupa'), isNot(notificationsOnColor));

    expect(tester.widget<Switch>(switchOf('dom')).value, isTrue);
    expect(bellColor(tester, 'dom'), notificationsOnColor);
  });

  testWidgets('flipping the switch turns notifications on for that group', (
    tester,
  ) async {
    await tester.pumpWidget(localizedApp(const GroupsScreen()));
    await pumpDatabase(tester);

    await tester.tap(switchOf('moja-grupa'));
    await pumpDatabase(tester);

    expect(tester.widget<Switch>(switchOf('moja-grupa')).value, isTrue);
    expect(bellColor(tester, 'moja-grupa'), notificationsOnColor);
    expect(bellColor(tester, 'dom'), notificationsOnColor);
  });

  testWidgets('flipping the switch back turns notifications off', (
    tester,
  ) async {
    await tester.pumpWidget(localizedApp(const GroupsScreen()));
    await pumpDatabase(tester);

    await tester.tap(switchOf('dom'));
    await pumpDatabase(tester);

    expect(tester.widget<Switch>(switchOf('dom')).value, isFalse);
    expect(bellColor(tester, 'dom'), isNot(notificationsOnColor));
  });

  testWidgets('removing a group drops it from the list', (tester) async {
    await tester.pumpWidget(localizedApp(const GroupsScreen()));
    await pumpDatabase(tester);

    await tester.tap(
      find.descendant(of: cardOf('politechnika'), matching: find.byIcon(Icons.close)),
    );
    await pumpDatabase(tester);

    expect(find.text('Politechnika'), findsNothing);
    expect(find.byType(GroupCard), findsNWidgets(2));
  });

  testWidgets('says so when no group is left', (tester) async {
    await tester.pumpWidget(localizedApp(const GroupsScreen()));
    await pumpDatabase(tester);

    for (final id in ['moja-grupa', 'dom', 'politechnika']) {
      await tester.tap(
        find.descendant(of: cardOf(id), matching: find.byIcon(Icons.close)),
      );
      await pumpDatabase(tester);
    }

    expect(find.byType(GroupCard), findsNothing);
    expect(find.text('Nie masz jeszcze żadnych grup.'), findsOneWidget);
  });

  testWidgets('the add-group button is shown only on the groups tab', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          groupsProvider.overrideWith(TestGroupsNotifier.new),
        ],
        child: MaterialApp(
          locale: const Locale('pl'),
          localizationsDelegates: [
            S.delegate,
            ...GlobalMaterialLocalizations.delegates,
          ],
          supportedLocales: S.delegate.supportedLocales,
          theme: ThemeData(colorScheme: MaterialTheme.darkScheme()),
          home: const HomeScreen(),
        ),
      ),
    );
    await pumpDatabase(tester);

    expect(find.byType(AddGroupButton), findsNothing);

    await tester.tap(find.byIcon(Icons.home));
    await pumpDatabase(tester);

    expect(find.byType(AddGroupButton), findsOneWidget);
  });
}
