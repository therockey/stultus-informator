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
