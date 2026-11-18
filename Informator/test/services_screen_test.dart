import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:informator/generated/l10n.dart';
import 'package:informator/models/notification_preferences.dart';
import 'package:informator/models/service.dart';
import 'package:informator/models/service_details.dart';
import 'package:informator/providers/service_details_provider.dart';
import 'package:informator/providers/services_provider.dart';
import 'package:informator/providers/shared_preferences_provider.dart';
import 'package:informator/screens/home/service_details_screen.dart';
import 'package:informator/screens/home/services_screen.dart';
import 'package:informator/widgets/service_card.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _sampleServices = <Service>[
  Service(
    id: 'netia',
    name: 'Netia',
    status: ServiceStatus.outage,
    groups: ['Dom', 'Media'],
  ),
  Service(
    id: 'openai',
    name: 'OpenAI',
    status: ServiceStatus.degraded,
    groups: ['Serwis'],
  ),
  Service(
    id: 'grygry2',
    name: 'GryGry2',
    status: ServiceStatus.operational,
    groups: ['Gry', 'Serwis'],
  ),
];

ServiceDetails get _netiaDetails => ServiceDetails(
  service: _sampleServices.first,
  notifications: const ServiceNotificationSettings(),
  cause: 'Uszkodzenie linii światłowodowej na odcinku Grunwaldzka',
  eta: DateTime(2026, 11, 17, 14),
  nearbyReportsLastHour: 47,
  localStreets: const ['Grunwaldzka', 'Kościuszki'],
  allStreets: const ['Grunwaldzka', 'Kościuszki', 'Ślężna'],
);

Widget localizedApp(
  Widget child, {
  List<Service>? services,
  SharedPreferences? prefs,
  ServiceDetails? details,
}) {
  return ProviderScope(
    overrides: [
      servicesProvider.overrideWith(
        (ref) async => services ?? _sampleServices,
      ),
      if (prefs != null) sharedPreferencesProvider.overrideWithValue(prefs),
      if (details != null)
        serviceDetailsProvider(details.service.id).overrideWith(
          (ref) async => details,
        ),
    ],
    child: MaterialApp(
      locale: const Locale('pl'),
      localizationsDelegates: [S.delegate, ...GlobalMaterialLocalizations.delegates],
      supportedLocales: S.delegate.supportedLocales,
      home: Scaffold(body: child),
    ),
  );
}

Future<void> pumpDatabase(WidgetTester tester) async {
  await tester.pump();
  await tester.runAsync(() => Future<void>.delayed(const Duration(seconds: 3)));
  await tester.pump();
}

void main() {
  testWidgets('lists popular services before the user searches', (tester) async {
    await tester.pumpWidget(localizedApp(const ServicesScreen()));
    await pumpDatabase(tester);

    expect(find.text('Popularne usługi'), findsOneWidget);
    expect(find.byType(ServiceCard), findsWidgets);
    expect(find.text('Netia'), findsOneWidget);
    expect(find.text('OpenAI'), findsOneWidget);
    expect(find.text('GryGry2'), findsOneWidget);
  });

  testWidgets('filters the list by the typed service name', (tester) async {
    await tester.pumpWidget(localizedApp(const ServicesScreen()));
    await pumpDatabase(tester);

    await tester.enterText(find.byType(TextField), 'net');
    await tester.pumpAndSettle();

    expect(find.text('Popularne usługi'), findsNothing);
    expect(find.byType(ServiceCard), findsOneWidget);
    expect(find.text('Netia'), findsOneWidget);
  });

  testWidgets('shows a message when no service matches', (tester) async {
    await tester.pumpWidget(localizedApp(const ServicesScreen()));
    await pumpDatabase(tester);

    await tester.enterText(find.byType(TextField), 'nie-ma-takiej-uslugi');
    await tester.pumpAndSettle();

    expect(find.byType(ServiceCard), findsNothing);
    expect(find.text('Nie znaleziono usług o tej nazwie.'), findsOneWidget);
  });

  testWidgets('service card shows the groups and both actions', (tester) async {
    var outageReports = 0;

    await tester.pumpWidget(
      localizedApp(
        ServiceCard(
          service: const Service(
            id: 'netia',
            name: 'Netia',
            status: ServiceStatus.outage,
            groups: <String>['Dom', 'Media'],
          ),
          onReportOutage: () => outageReports++,
          onAddToGroup: () {},
        ),
      ),
    );
    await pumpDatabase(tester);

    expect(find.text('Netia'), findsOneWidget);
    expect(find.text('Dom'), findsOneWidget);
    expect(find.text('Media'), findsOneWidget);
    expect(find.text('Zgłoś awarię'), findsOneWidget);
    expect(find.text('Dodaj do grupy'), findsOneWidget);

    await tester.tap(find.text('Zgłoś awarię'));
    expect(outageReports, 1);
  });

  testWidgets('service card shows a text status next to the name', (tester) async {
    await tester.pumpWidget(
      localizedApp(
        ServiceCard(
          service: _sampleServices.first,
          onReportOutage: () {},
          onAddToGroup: () {},
        ),
      ),
    );
    await pumpDatabase(tester);

    expect(find.text('Awaria'), findsOneWidget);
    expect(find.text('Netia'), findsOneWidget);
  });

  testWidgets('tapping the service block opens details', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      localizedApp(
        const ServicesScreen(),
        prefs: prefs,
        details: _netiaDetails,
      ),
    );
    await pumpDatabase(tester);

    await tester.tap(find.text('Netia'));
    await tester.pumpAndSettle();

    expect(find.byType(ServiceDetailsScreen), findsOneWidget);
    expect(
      find.text('Uszkodzenie linii światłowodowej na odcinku Grunwaldzka'),
      findsOneWidget,
    );
    expect(find.textContaining('47'), findsOneWidget);
  });

  testWidgets('report action does not open details', (tester) async {
    await tester.pumpWidget(localizedApp(const ServicesScreen()));
    await pumpDatabase(tester);

    await tester.tap(find.text('Zgłoś awarię').first);
    await tester.pump();

    expect(find.byType(ServiceDetailsScreen), findsNothing);
    expect(
      find.text('Zgłaszanie awarii będzie dostępne w kolejnej wersji.'),
      findsOneWidget,
    );
  });

  testWidgets('service card action buttons share the same width',
      (tester) async {
    await tester.pumpWidget(
      localizedApp(
        ServiceCard(
          service: const Service(
            id: 'netia',
            name: 'Netia',
            status: ServiceStatus.operational,
            groups: <String>['Dom'],
          ),
          onReportOutage: () {},
          onAddToGroup: () {},
        ),
      ),
    );
    await pumpDatabase(tester);

    final buttons = find.byType(ServiceActionButton);
    expect(buttons, findsNWidgets(2));
    expect(
      tester.getSize(buttons.at(0)).width,
      tester.getSize(buttons.at(1)).width,
    );
  });
}
