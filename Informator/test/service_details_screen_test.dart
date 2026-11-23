import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:informator/generated/l10n.dart';
import 'package:informator/models/notification_preferences.dart';
import 'package:informator/models/service.dart';
import 'package:informator/models/service_details.dart';
import 'package:informator/providers/service_details_provider.dart';
import 'package:informator/providers/shared_preferences_provider.dart';
import 'package:informator/screens/home/service_details_screen.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _netia = ServiceDetails(
  service: const Service(
    id: 'netia',
    name: 'Netia',
    status: ServiceStatus.outage,
    groups: ['Dom', 'Media'],
  ),
  notifications: const ServiceNotificationSettings(),
  cause: 'Uszkodzenie linii światłowodowej na odcinku Grunwaldzka',
  windowStart: DateTime(2026, 11, 17, 6, 30),
  windowEnd: DateTime(2026, 11, 17, 16),
  eta: DateTime(2026, 11, 17, 14),
  progress: 40,
  source: OutageSource.official,
  nearbyReportsLastHour: 47,
  localStreets: const ['Grunwaldzka', 'Kościuszki'],
  allStreets: const ['Grunwaldzka', 'Kościuszki', 'Ślężna'],
  reportPoints: [
    ReportPoint(day: DateTime(2026, 11, 16), count: 20),
    ReportPoint(day: DateTime(2026, 11, 17), count: 47),
  ],
);

Future<Widget> detailsApp({bool simplified = false}) async {
  SharedPreferences.setMockInitialValues({
    if (simplified) 'simplified_mode': true,
  });
  final prefs = await SharedPreferences.getInstance();

  return ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
      serviceDetailsProvider('netia').overrideWith((ref) async => _netia),
    ],
    child: MaterialApp(
      locale: const Locale('pl'),
      localizationsDelegates: [
        S.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: const ServiceDetailsScreen(serviceId: 'netia'),
    ),
  );
}

void main() {
  testWidgets('shows cause, ETA and nearby report count', (tester) async {
    tester.view.physicalSize = const Size(412, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(await detailsApp());
    await tester.pumpAndSettle();

    expect(find.text('Netia'), findsWidgets);
    expect(find.text('Awaria'), findsOneWidget);
    expect(
      find.text('Uszkodzenie linii światłowodowej na odcinku Grunwaldzka'),
      findsOneWidget,
    );
    expect(find.textContaining('47'), findsOneWidget);
  });

  testWidgets('simplified mode shows at most three facts', (tester) async {
    await tester.pumpWidget(await detailsApp(simplified: true));
    await tester.pumpAndSettle();

    final column = tester.widget<Column>(
      find.byKey(const Key('simplified-info')),
    );
    final factCount = column.children
        .where((child) => child is! SizedBox)
        .length;
    expect(factCount, lessThanOrEqualTo(3));
    expect(find.text('Awaria'), findsOneWidget);
    expect(
      find.text('Uszkodzenie linii światłowodowej na odcinku Grunwaldzka'),
      findsOneWidget,
    );
  });
}
