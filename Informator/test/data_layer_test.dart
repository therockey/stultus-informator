import 'package:flutter_test/flutter_test.dart';
import 'package:informator/data/app_database.dart';
import 'package:informator/data/informator_repository.dart';
import 'package:informator/models/notification_preferences.dart';
import 'package:informator/models/service.dart';

void main() {
  test('seeds and queries services and groups', () async {
    final repository = InformatorRepository(AppDatabase.forTesting());

    final groups = await repository.fetchGroups();
    final services = await repository.fetchServices();

    expect(groups.map((group) => group.id), [
      'moja-grupa',
      'dom',
      'politechnika',
    ]);
    expect(services.map((service) => service.id), [
      'netia',
      'openai',
      'grygry2',
      'tauron',
      'veolia',
      'mpk',
    ]);
    expect(services.first.groups, ['Dom', 'Media']);
    expect(services[1].groups, ['Serwis']);
  });

  test('persists group changes', () async {
    final repository = InformatorRepository(AppDatabase.forTesting());

    await repository.updateGroupNotifications('moja-grupa', true);
    await repository.deleteGroup('politechnika');

    final groups = await repository.fetchGroups();
    expect(groups.first.notificationsEnabled, isTrue);
    expect(groups.any((group) => group.id == 'politechnika'), isFalse);
  });

  test('seeds outage details for Netia and Veolia', () async {
    final repository = InformatorRepository(AppDatabase.forTesting());

    final netia = await repository.fetchServiceDetails('netia');
    expect(netia.service.status, ServiceStatus.outage);
    expect(netia.cause, contains('światłowodowej'));
    expect(netia.nearbyReportsLastHour, 47);
    expect(netia.isPlanned, isFalse);
    expect(netia.eta, isNotNull);
    expect(netia.localStreets, isNotEmpty);

    final veolia = await repository.fetchServiceDetails('veolia');
    expect(veolia.isPlanned, isTrue);
    expect(veolia.cause, contains('konserwacja'));

    final tauron = await repository.fetchServiceDetails('tauron');
    expect(tauron.service.status, ServiceStatus.operational);
    expect(tauron.cause, isNull);
  });

  test('persists notification rules for a service', () async {
    final repository = InformatorRepository(AppDatabase.forTesting());

    await repository.updateServiceNotifications(
      serviceId: 'veolia',
      enabled: true,
      rule: NotificationRule.plannedOnly,
      leadTime: NotificationLeadTime.oneDay,
    );

    final details = await repository.fetchServiceDetails('veolia');
    expect(details.notifications.enabled, isTrue);
    expect(details.notifications.rule, NotificationRule.plannedOnly);
    expect(details.notifications.leadTime, NotificationLeadTime.oneDay);
  });
}
