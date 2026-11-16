import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:informator/generated/l10n.dart';
import 'package:informator/models/service.dart';
import 'package:informator/providers/services_provider.dart';
import 'package:informator/screens/home/services_screen.dart';
import 'package:informator/widgets/service_card.dart';
import 'package:material_ui/material_ui.dart';

Widget localizedApp(Widget child, {List<Service>? services}) {
  return ProviderScope(
    overrides: [
      if (services != null) servicesProvider.overrideWithValue(services),
    ],
    child: MaterialApp(
      locale: const Locale('pl'),
      localizationsDelegates: [S.delegate, ...GlobalMaterialLocalizations.delegates],
      supportedLocales: S.delegate.supportedLocales,
      home: Scaffold(body: child),
    ),
  );
}

void main() {
  testWidgets('lists popular services before the user searches', (tester) async {
    await tester.pumpWidget(localizedApp(const ServicesScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Popularne usługi'), findsOneWidget);
    expect(find.byType(ServiceCard), findsWidgets);
    expect(find.text('Netia'), findsOneWidget);
    expect(find.text('OpenAI'), findsOneWidget);
    expect(find.text('GryGry2'), findsOneWidget);
  });

  testWidgets('filters the list by the typed service name', (tester) async {
    await tester.pumpWidget(localizedApp(const ServicesScreen()));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'net');
    await tester.pumpAndSettle();

    expect(find.text('Popularne usługi'), findsNothing);
    expect(find.byType(ServiceCard), findsOneWidget);
    expect(find.text('Netia'), findsOneWidget);
  });

  testWidgets('shows a message when no service matches', (tester) async {
    await tester.pumpWidget(localizedApp(const ServicesScreen()));
    await tester.pumpAndSettle();

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
    await tester.pumpAndSettle();

    expect(find.text('Netia'), findsOneWidget);
    expect(find.text('Dom'), findsOneWidget);
    expect(find.text('Media'), findsOneWidget);
    expect(find.text('Zgłoś awarię'), findsOneWidget);
    expect(find.text('Dodaj do grupy'), findsOneWidget);

    await tester.tap(find.text('Zgłoś awarię'));
    expect(outageReports, 1);
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
    await tester.pumpAndSettle();

    final buttons = find.byType(ServiceActionButton);
    expect(buttons, findsNWidgets(2));
    expect(
      tester.getSize(buttons.at(0)).width,
      tester.getSize(buttons.at(1)).width,
    );
  });
}
