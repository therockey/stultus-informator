
import 'package:informator/data/app_database.dart';
import 'package:informator/models/group.dart';
import 'package:informator/models/service.dart';

class InformatorRepository {
  InformatorRepository(this._database);

  final AppDatabase _database;

  Future<List<Group>> fetchGroups() async {
    final database = await _database.database;
    final rows = await database.query('groups', orderBy: 'rowid');

    return [
      for (final row in rows)
        Group(
          id: row['id']! as String,
          name: row['name']! as String,
          location: row['location'] as String?,
          notificationsEnabled: (row['notifications_enabled']! as int) == 1,
        ),
    ];
  }

  Future<Group> createGroup(String name) async {
    final database = await _database.database;

    final group = Group(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      name: name,
    );

    await database.insert('groups', {
      'id': group.id,
      'name': group.name,
      'location': null,
      'notifications_enabled': 0,
    });

    return group;
  }


Future<void> addServiceToGroup(
  String serviceId,
  String groupName,
) async {
  final database = await _database.database;

  final existing = await database.query(
    'service_groups',
    columns: ['service_id'],
    where: 'service_id = ? AND name = ?',
    whereArgs: [serviceId, groupName],
    limit: 1,
  );

  if (existing.isNotEmpty) {
    return;
  }

  final result = await database.rawQuery(
    '''
    SELECT COALESCE(MAX(position), -1) + 1 AS next_position
    FROM service_groups
    WHERE service_id = ?
    ''',
    [serviceId],
  );

  final position = (result.first['next_position'] as int?) ?? 0;

  await database.insert('service_groups', {
    'service_id': serviceId,
    'name': groupName,
    'position': position,
  });
}


  Future<List<Service>> fetchServices() async {
    final database = await _database.database;
    final rows = await database.rawQuery('''
      SELECT
        services.id,
        services.name,
        services.status,
        GROUP_CONCAT(service_groups.name, '|') AS group_names
      FROM services
      LEFT JOIN service_groups
        ON service_groups.service_id = services.id
       GROUP BY services.id, services.name, services.status
      ORDER BY services.rowid
    ''');

    return [
      for (final row in rows)
        Service(
          id: row['id']! as String,
          name: row['name']! as String,
          status: ServiceStatus.values.byName(row['status']! as String),
          groups: (row['group_names'] as String?)
                  ?.split('|')
                  .where((group) => group.isNotEmpty)
                  .toList(growable: false) ??
              const <String>[],
        ),
    ];
  }

  Future<void> updateGroupNotifications(String groupId, bool enabled) async {
    final database = await _database.database;
    await database.update(
      'groups',
      {'notifications_enabled': enabled ? 1 : 0},
      where: 'id = ?',
      whereArgs: [groupId],
    );
  }

  Future<void> deleteGroup(String groupId) async {
    final database = await _database.database;
    await database.delete(
      'groups',
      where: 'id = ?',
      whereArgs: [groupId],
    );
  }
}
