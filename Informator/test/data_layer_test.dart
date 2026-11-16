import 'package:flutter_test/flutter_test.dart';
import 'package:informator/data/app_database.dart';
import 'package:informator/data/informator_repository.dart';

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
}
