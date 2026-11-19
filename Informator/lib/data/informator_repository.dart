
import 'package:informator/data/app_database.dart';
import 'package:informator/models/group.dart';
import 'package:informator/models/notification_preferences.dart';
import 'package:informator/models/service.dart';
import 'package:informator/models/service_details.dart';
import 'package:informator/models/transport.dart';
import 'package:sqflite/sqflite.dart';

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
      for (final row in rows) _serviceFromRow(row),
    ];
  }

  Future<ServiceDetails> fetchServiceDetails(String serviceId) async {
    final database = await _database.database;
    final rows = await database.rawQuery(
      '''
      SELECT
        services.id,
        services.name,
        services.status,
        GROUP_CONCAT(service_groups.name, '|') AS group_names,
        service_outages.cause,
        service_outages.window_start,
        service_outages.window_end,
        service_outages.eta,
        service_outages.progress,
        service_outages.source,
        service_outages.is_planned,
        service_outages.official_url,
        service_outages.last_checked,
        service_outages.nearby_reports_last_hour,
        service_outages.local_streets,
        service_outages.all_streets,
        service_outages.distressing_note,
        service_notifications.enabled AS notifications_enabled,
        service_notifications.rule AS notifications_rule,
        service_notifications.lead_time AS notifications_lead_time
      FROM services
      LEFT JOIN service_groups
        ON service_groups.service_id = services.id
      LEFT JOIN service_outages
        ON service_outages.service_id = services.id
      LEFT JOIN service_notifications
        ON service_notifications.service_id = services.id
      WHERE services.id = ?
      GROUP BY services.id
      ''',
      [serviceId],
    );

    if (rows.isEmpty) {
      throw StateError('Unknown service: $serviceId');
    }

    final row = rows.first;
    final pointRows = await database.query(
      'service_report_points',
      where: 'service_id = ?',
      whereArgs: [serviceId],
      orderBy: 'day',
    );

    return ServiceDetails(
      service: _serviceFromRow(row),
      cause: row['cause'] as String?,
      windowStart: _dateTimeFrom(row['window_start']),
      windowEnd: _dateTimeFrom(row['window_end']),
      eta: _dateTimeFrom(row['eta']),
      progress: row['progress'] as int?,
      source: _sourceFrom(row['source'] as String?),
      isPlanned: (row['is_planned'] as int?) == 1,
      officialUrl: row['official_url'] as String?,
      lastChecked: _dateTimeFrom(row['last_checked']),
      nearbyReportsLastHour: (row['nearby_reports_last_hour'] as int?) ?? 0,
      localStreets: _splitList(row['local_streets'] as String?),
      allStreets: _splitList(row['all_streets'] as String?),
      distressingNote: row['distressing_note'] as String?,
      reportPoints: [
        for (final point in pointRows)
          ReportPoint(
            day: DateTime.fromMillisecondsSinceEpoch(point['day']! as int),
            count: point['count']! as int,
          ),
      ],
      notifications: ServiceNotificationSettings(
        enabled: (row['notifications_enabled'] as int?) == 1,
        rule: NotificationRule.values.byName(
          (row['notifications_rule'] as String?) ?? 'all',
        ),
        leadTime: NotificationLeadTime.values.byName(
          (row['notifications_lead_time'] as String?) ?? 'none',
        ),
      ),
    );
  }

  Future<List<TransportLine>> fetchTransportLines() async {
    final database = await _database.database;
    final lineRows = await database.rawQuery('''
      SELECT
        transport_lines.id,
        transport_lines.name,
        transport_lines.short_name,
        transport_lines.kind,
        transport_lines.status,
        transport_outages.disrupted_from,
        transport_outages.disrupted_to
      FROM transport_lines
      LEFT JOIN transport_outages
        ON transport_outages.line_id = transport_lines.id
      ORDER BY transport_lines.position
    ''');
    final routeRows = await database.query(
      'transport_route_points',
      orderBy: 'line_id, seq',
    );
    final delayRows = await database.query(
      'transport_delay_points',
      orderBy: 'line_id, recorded_at',
    );

    final routes = <String, List<TransportRoutePoint>>{};
    for (final row in routeRows) {
      routes.putIfAbsent(row['line_id']! as String, () => []).add(
        _routePointFromRow(row),
      );
    }
    final delays = <String, List<TransportDelayPoint>>{};
    for (final row in delayRows) {
      delays.putIfAbsent(row['line_id']! as String, () => []).add(
        _delayPointFromRow(row),
      );
    }

    return [
      for (final row in lineRows)
        _transportLineFromRow(
          row,
          routes[row['id']! as String] ?? const <TransportRoutePoint>[],
          delays[row['id']! as String] ?? const <TransportDelayPoint>[],
        ),
    ];
  }

  Future<TransportLineDetails> fetchTransportLineDetails(String lineId) async {
    final database = await _database.database;
    final rows = await database.rawQuery(
      '''
      SELECT
        transport_lines.id,
        transport_lines.name,
        transport_lines.short_name,
        transport_lines.kind,
        transport_lines.status,
        transport_outages.cause,
        transport_outages.started_at,
        transport_outages.eta,
        transport_outages.source,
        transport_outages.last_checked,
        transport_outages.disrupted_from,
        transport_outages.disrupted_to,
        transport_outages.area_x,
        transport_outages.area_y,
        transport_outages.area_radius
      FROM transport_lines
      LEFT JOIN transport_outages
        ON transport_outages.line_id = transport_lines.id
      WHERE transport_lines.id = ?
      ''',
      [lineId],
    );

    if (rows.isEmpty) {
      throw StateError('Unknown transport line: $lineId');
    }

    final row = rows.first;
    final routeRows = await database.query(
      'transport_route_points',
      where: 'line_id = ?',
      whereArgs: [lineId],
      orderBy: 'seq',
    );
    final delayRows = await database.query(
      'transport_delay_points',
      where: 'line_id = ?',
      whereArgs: [lineId],
      orderBy: 'recorded_at',
    );
    final detourRows = await database.query(
      'transport_detours',
      where: 'line_id = ?',
      whereArgs: [lineId],
      orderBy: 'position',
    );

    return TransportLineDetails(
      line: _transportLineFromRow(
        row,
        [for (final point in routeRows) _routePointFromRow(point)],
        [for (final point in delayRows) _delayPointFromRow(point)],
      ),
      cause: row['cause'] as String?,
      startedAt: _dateTimeFrom(row['started_at']),
      eta: _dateTimeFrom(row['eta']),
      source: _sourceFrom(row['source'] as String?),
      lastChecked: _dateTimeFrom(row['last_checked']),
      areaX: (row['area_x'] as num?)?.toDouble(),
      areaY: (row['area_y'] as num?)?.toDouble(),
      areaRadius: (row['area_radius'] as num?)?.toDouble(),
      detours: [
        for (final detour in detourRows)
          TransportDetour(
            fromLine: detour['from_line']! as String,
            toLine: detour['to_line']! as String,
          ),
      ],
    );
  }

  TransportLine _transportLineFromRow(
    Map<String, Object?> row,
    List<TransportRoutePoint> route,
    List<TransportDelayPoint> delays,
  ) {
    return TransportLine(
      id: row['id']! as String,
      name: row['name']! as String,
      shortName: row['short_name']! as String,
      kind: TransportKind.values.byName(row['kind']! as String),
      status: ServiceStatus.values.byName(row['status']! as String),
      route: route,
      delays: delays,
      disruptedFrom: row['disrupted_from'] as int?,
      disruptedTo: row['disrupted_to'] as int?,
    );
  }

  TransportRoutePoint _routePointFromRow(Map<String, Object?> row) {
    return TransportRoutePoint(
      x: (row['x']! as num).toDouble(),
      y: (row['y']! as num).toDouble(),
    );
  }

  TransportDelayPoint _delayPointFromRow(Map<String, Object?> row) {
    return TransportDelayPoint(
      time: DateTime.fromMillisecondsSinceEpoch(row['recorded_at']! as int),
      minutes: row['delay_minutes']! as int,
    );
  }

  Future<void> updateServiceNotifications({
    required String serviceId,
    bool? enabled,
    NotificationRule? rule,
    NotificationLeadTime? leadTime,
  }) async {
    final current = await fetchServiceDetails(serviceId);
    final next = current.notifications.copyWith(
      enabled: enabled,
      rule: rule,
      leadTime: leadTime,
    );
    final database = await _database.database;
    await database.insert(
      'service_notifications',
      {
        'service_id': serviceId,
        'enabled': next.enabled ? 1 : 0,
        'rule': next.rule.name,
        'lead_time': next.leadTime.name,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
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

  Service _serviceFromRow(Map<String, Object?> row) {
    return Service(
      id: row['id']! as String,
      name: row['name']! as String,
      status: ServiceStatus.values.byName(row['status']! as String),
      groups: _splitList(row['group_names'] as String?),
    );
  }

  static DateTime? _dateTimeFrom(Object? value) {
    if (value is! int) {
      return null;
    }
    return DateTime.fromMillisecondsSinceEpoch(value);
  }

  static OutageSource? _sourceFrom(String? value) {
    if (value == null) {
      return null;
    }
    return OutageSource.values.byName(value);
  }

  static List<String> _splitList(String? value) {
    return value
            ?.split('|')
            .where((item) => item.isNotEmpty)
            .toList(growable: false) ??
        const <String>[];
  }
}
