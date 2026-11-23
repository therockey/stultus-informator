import 'dart:io';
import 'dart:math';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  AppDatabase._([this._databasePath]);

  static final AppDatabase instance = AppDatabase._();

  static const _databaseName = 'informator.db';
  static const _databaseVersion = 4;

  final String? _databasePath;

  Database? _database;

  factory AppDatabase.forTesting() =>
      AppDatabase._(
        join(
          Directory.systemTemp.path,
          'informator_test_${DateTime.now().microsecondsSinceEpoch}_'
              '${Random().nextInt(1 << 32)}.db',
        ),
      );

  Future<Database> get database async {
    final existing = _database;
    if (existing != null) {
      return existing;
    }

    final databasePath = _databasePath ?? join(await getDatabasesPath(), _databaseName);
    final database = await openDatabase(
      databasePath,
      version: _databaseVersion,
      onCreate: _createDatabase,
      onUpgrade: _upgradeDatabase,
      onDowngrade: (database, oldVersion, newVersion) async {},
    );
    _database = database;
    return database;
  }

  Future<void> _createDatabase(Database database, int version) async {
    await database.execute('''
      CREATE TABLE groups (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        location TEXT,
        notifications_enabled INTEGER NOT NULL DEFAULT 0
      )
    ''');
    await database.execute('''
      CREATE TABLE services (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        status TEXT NOT NULL
      )
    ''');
    await database.execute('''
      CREATE TABLE group_services (
        group_id TEXT NOT NULL,
        service_id TEXT NOT NULL,
        position INTEGER NOT NULL,
        PRIMARY KEY (group_id, service_id),
        FOREIGN KEY (group_id) REFERENCES groups(id) ON DELETE CASCADE,
        FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE CASCADE
      )
    ''');
    await database.execute('''
      CREATE TABLE service_groups (
        service_id TEXT NOT NULL,
        name TEXT NOT NULL,
        position INTEGER NOT NULL,
        PRIMARY KEY (service_id, name),
        FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE CASCADE
      )
    ''');
    await _createOutageTables(database);
    await _createTransportTables(database);
    await _seed(database);
  }

  Future<void> _upgradeDatabase(
    Database database,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < 2) {
      await database.execute('''
        CREATE TABLE IF NOT EXISTS service_groups (
          service_id TEXT NOT NULL,
          name TEXT NOT NULL,
          position INTEGER NOT NULL,
          PRIMARY KEY (service_id, name),
          FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE CASCADE
        )
      ''');
      await _seedServiceGroups(database);
    }
    if (oldVersion < 3) {
      await _createOutageTables(database);
      await _seedServiceOutages(database);
      await _seedServiceNotifications(database);
    }
    if (oldVersion < 4) {
      await _createTransportTables(database);
      await _seedTransport(database);
    }
  }

  Future<void> _createOutageTables(Database database) async {
    await database.execute('''
      CREATE TABLE IF NOT EXISTS service_outages (
        service_id TEXT PRIMARY KEY,
        cause TEXT,
        window_start INTEGER,
        window_end INTEGER,
        eta INTEGER,
        progress INTEGER,
        source TEXT,
        is_planned INTEGER NOT NULL DEFAULT 0,
        official_url TEXT,
        last_checked INTEGER,
        nearby_reports_last_hour INTEGER NOT NULL DEFAULT 0,
        local_streets TEXT,
        all_streets TEXT,
        distressing_note TEXT,
        FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE CASCADE
      )
    ''');
    await database.execute('''
      CREATE TABLE IF NOT EXISTS service_report_points (
        service_id TEXT NOT NULL,
        day INTEGER NOT NULL,
        count INTEGER NOT NULL,
        PRIMARY KEY (service_id, day),
        FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE CASCADE
      )
    ''');
    await database.execute('''
      CREATE TABLE IF NOT EXISTS service_notifications (
        service_id TEXT PRIMARY KEY,
        enabled INTEGER NOT NULL DEFAULT 0,
        rule TEXT NOT NULL DEFAULT 'all',
        lead_time TEXT NOT NULL DEFAULT 'none',
        FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE CASCADE
      )
    ''');
  }

  /// Public transport: lines, their schematic geometry, the current
  /// disruption, suggested detours and the delay history shown in charts.
  Future<void> _createTransportTables(Database database) async {
    await database.execute('''
      CREATE TABLE IF NOT EXISTS transport_lines (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        short_name TEXT NOT NULL,
        kind TEXT NOT NULL,
        status TEXT NOT NULL,
        position INTEGER NOT NULL
      )
    ''');
    // Coordinates are normalised to 0..1 so the schematic map can be drawn at
    // any size without a map SDK.
    await database.execute('''
      CREATE TABLE IF NOT EXISTS transport_route_points (
        line_id TEXT NOT NULL,
        seq INTEGER NOT NULL,
        x REAL NOT NULL,
        y REAL NOT NULL,
        PRIMARY KEY (line_id, seq),
        FOREIGN KEY (line_id) REFERENCES transport_lines(id) ON DELETE CASCADE
      )
    ''');
    await database.execute('''
      CREATE TABLE IF NOT EXISTS transport_outages (
        line_id TEXT PRIMARY KEY,
        cause TEXT,
        started_at INTEGER,
        eta INTEGER,
        source TEXT,
        last_checked INTEGER,
        disrupted_from INTEGER,
        disrupted_to INTEGER,
        area_x REAL,
        area_y REAL,
        area_radius REAL,
        FOREIGN KEY (line_id) REFERENCES transport_lines(id) ON DELETE CASCADE
      )
    ''');
    await database.execute('''
      CREATE TABLE IF NOT EXISTS transport_detours (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        line_id TEXT NOT NULL,
        from_line TEXT NOT NULL,
        to_line TEXT NOT NULL,
        position INTEGER NOT NULL,
        FOREIGN KEY (line_id) REFERENCES transport_lines(id) ON DELETE CASCADE
      )
    ''');
    await database.execute('''
      CREATE TABLE IF NOT EXISTS transport_delay_points (
        line_id TEXT NOT NULL,
        recorded_at INTEGER NOT NULL,
        delay_minutes INTEGER NOT NULL,
        PRIMARY KEY (line_id, recorded_at),
        FOREIGN KEY (line_id) REFERENCES transport_lines(id) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> _seedTransport(
    Database database, {
    Batch? batch,
  }) async {
    final target = batch ?? database.batch();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    const lines = <({
      String id,
      String short,
      String kind,
      String status,
      List<(double, double)> route,
      List<int> delays,
    })>[
      (
        id: 'tram-10',
        short: '10',
        kind: 'tram',
        status: 'degraded',
        route: [(0.05, 0.50), (0.30, 0.50), (0.55, 0.55), (0.80, 0.50), (0.95, 0.45)],
        delays: [0, 0, 0, 1, 1, 2, 3, 4, 5, 6, 6, 7],
      ),
      (
        id: 'tram-12',
        short: '12',
        kind: 'tram',
        status: 'outage',
        route: [(0.05, 0.80), (0.25, 0.65), (0.45, 0.55), (0.60, 0.40), (0.80, 0.25), (0.95, 0.20)],
        delays: [0, 0, 1, 0, 2, 5, 9, 14, 18, 22, 25, 27],
      ),
      (
        id: 'tram-13',
        short: '13',
        kind: 'tram',
        status: 'outage',
        route: [(0.10, 0.20), (0.30, 0.35), (0.50, 0.50), (0.70, 0.65), (0.90, 0.80)],
        delays: [0, 1, 0, 0, 3, 6, 10, 12, 15, 20, 24, 26],
      ),
      (
        id: 'tram-15',
        short: '15',
        kind: 'tram',
        status: 'operational',
        route: [(0.20, 0.95), (0.35, 0.75), (0.50, 0.55), (0.65, 0.30), (0.75, 0.05)],
        delays: [0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0],
      ),
      (
        id: 'bus-17',
        short: '17',
        kind: 'bus',
        status: 'operational',
        route: [(0.05, 0.10), (0.35, 0.12), (0.60, 0.30), (0.90, 0.35)],
        delays: [1, 0, 0, 1, 0, 0, 2, 0, 1, 0, 0, 1],
      ),
    ];

    for (var index = 0; index < lines.length; index++) {
      final line = lines[index];
      target.insert('transport_lines', {
        'id': line.id,
        'name': 'Linia ${line.short}',
        'short_name': line.short,
        'kind': line.kind,
        'status': line.status,
        'position': index,
      }, conflictAlgorithm: ConflictAlgorithm.ignore);

      for (var seq = 0; seq < line.route.length; seq++) {
        target.insert('transport_route_points', {
          'line_id': line.id,
          'seq': seq,
          'x': line.route[seq].$1,
          'y': line.route[seq].$2,
        }, conflictAlgorithm: ConflictAlgorithm.ignore);
      }

      final currentHour = DateTime(now.year, now.month, now.day, now.hour);
      for (var i = 0; i < line.delays.length; i++) {
        final recordedAt = currentHour.subtract(
          Duration(hours: line.delays.length - 1 - i),
        );
        target.insert('transport_delay_points', {
          'line_id': line.id,
          'recorded_at': recordedAt.millisecondsSinceEpoch,
          'delay_minutes': line.delays[i],
        }, conflictAlgorithm: ConflictAlgorithm.ignore);
      }
    }

    target.insert('transport_outages', {
      'line_id': 'tram-12',
      'cause': 'Awaria zasilania sieci trakcyjnej na odcinku Hallera – Plac Grunwaldzki',
      'started_at': today.add(const Duration(hours: 7, minutes: 10)).millisecondsSinceEpoch,
      'eta': today.add(const Duration(hours: 15, minutes: 30)).millisecondsSinceEpoch,
      'source': 'official',
      'last_checked': now.millisecondsSinceEpoch,
      'disrupted_from': 2,
      'disrupted_to': 4,
      'area_x': 0.52,
      'area_y': 0.47,
      'area_radius': 0.15,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
    target.insert('transport_outages', {
      'line_id': 'tram-13',
      'cause': 'Zablokowane tory na skrzyżowaniu Ślężna / Powstańców',
      'started_at': today.add(const Duration(hours: 8)).millisecondsSinceEpoch,
      'eta': today.add(const Duration(hours: 14)).millisecondsSinceEpoch,
      'source': 'official',
      'last_checked': now.millisecondsSinceEpoch,
      'disrupted_from': 1,
      'disrupted_to': 3,
      'area_x': 0.42,
      'area_y': 0.43,
      'area_radius': 0.13,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
    target.insert('transport_outages', {
      'line_id': 'tram-10',
      'cause': 'Prace torowe – wolniejszy przejazd na części trasy',
      'started_at': today.add(const Duration(hours: 6)).millisecondsSinceEpoch,
      'eta': today.add(const Duration(hours: 12)).millisecondsSinceEpoch,
      'source': 'community',
      'last_checked': now.millisecondsSinceEpoch,
      'disrupted_from': 2,
      'disrupted_to': 3,
      'area_x': 0.68,
      'area_y': 0.52,
      'area_radius': 0.10,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);

    const detours = <String, List<(String, String)>>{
      'tram-12': [
        ('Linia 10', 'Linia 15'),
        ('Linia 10', 'Linia 17'),
        ('Linia 15', 'Linia 17'),
      ],
      'tram-13': [
        ('Linia 10', 'Linia 15'),
        ('Linia 15', 'Linia 17'),
      ],
    };
    for (final entry in detours.entries) {
      for (var index = 0; index < entry.value.length; index++) {
        target.insert('transport_detours', {
          'line_id': entry.key,
          'from_line': entry.value[index].$1,
          'to_line': entry.value[index].$2,
          'position': index,
        });
      }
    }

    if (batch == null) {
      await target.commit(noResult: true);
    }
  }

  Future<void> _seed(Database database) async {
    final batch = database.batch();
    batch.insert('groups', {
      'id': 'moja-grupa',
      'name': 'Twoja Grupa',
      'location': null,
      'notifications_enabled': 0,
    });
    batch.insert('groups', {
      'id': 'dom',
      'name': 'Dom',
      'location': 'Szarych Szeregów 2, Kalisz',
      'notifications_enabled': 1,
    });
    batch.insert('groups', {
      'id': 'politechnika',
      'name': 'Politechnika',
      'location': 'Grunwaldzka 15, Wrocław',
      'notifications_enabled': 1,
    });

    batch.insert('services', {
      'id': 'netia',
      'name': 'Netia',
      'status': 'outage',
    });
    batch.insert('services', {
      'id': 'openai',
      'name': 'OpenAI',
      'status': 'degraded',
    });
    batch.insert('services', {
      'id': 'grygry2',
      'name': 'GryGry2',
      'status': 'operational',
    });
    batch.insert('services', {
      'id': 'tauron',
      'name': 'Tauron',
      'status': 'operational',
    });
    batch.insert('services', {
      'id': 'veolia',
      'name': 'Veolia',
      'status': 'outage',
    });
    batch.insert('services', {
      'id': 'mpk',
      'name': 'MPK Wrocław',
      'status': 'operational',
    });

    const memberships = <String, List<String>>{
      'moja-grupa': <String>[],
      'dom': <String>['netia', 'tauron', 'veolia'],
      'politechnika': <String>['mpk'],
    };
    for (final entry in memberships.entries) {
      for (var index = 0; index < entry.value.length; index++) {
        batch.insert('group_services', {
          'group_id': entry.key,
          'service_id': entry.value[index],
          'position': index,
        });
      }
    }
    await _seedServiceGroups(database, batch: batch);
    await _seedServiceOutages(database, batch: batch);
    await _seedServiceNotifications(database, batch: batch);
    await _seedTransport(database, batch: batch);
    await batch.commit(noResult: true);
  }

  Future<void> _seedServiceGroups(
    Database database, {
    Batch? batch,
  }) async {
    final target = batch ?? database.batch();
    const serviceGroups = <String, List<String>>{
      'netia': <String>['Dom', 'Media'],
      'openai': <String>['Serwis'],
      'grygry2': <String>['Gry', 'Serwis'],
      'tauron': <String>['Dom'],
      'veolia': <String>['Dom', 'Media'],
      'mpk': <String>[],
    };
    for (final entry in serviceGroups.entries) {
      for (var index = 0; index < entry.value.length; index++) {
        target.insert(
          'service_groups',
          {
            'service_id': entry.key,
            'name': entry.value[index],
            'position': index,
          },
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      }
    }
    if (batch == null) {
      await target.commit(noResult: true);
    }
  }

  Future<void> _seedServiceNotifications(
    Database database, {
    Batch? batch,
  }) async {
    final target = batch ?? database.batch();
    const ids = <String>[
      'netia',
      'openai',
      'grygry2',
      'tauron',
      'veolia',
      'mpk',
    ];
    for (final id in ids) {
      target.insert(
        'service_notifications',
        {
          'service_id': id,
          'enabled': 0,
          'rule': 'all',
          'lead_time': 'none',
        },
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
    if (batch == null) {
      await target.commit(noResult: true);
    }
  }

  Future<void> _seedServiceOutages(
    Database database, {
    Batch? batch,
  }) async {
    final target = batch ?? database.batch();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    target.insert('service_outages', {
      'service_id': 'netia',
      'cause': 'Uszkodzenie linii światłowodowej na odcinku Grunwaldzka',
      'window_start': today.add(const Duration(hours: 6, minutes: 30)).millisecondsSinceEpoch,
      'window_end': today.add(const Duration(hours: 16)).millisecondsSinceEpoch,
      'eta': today.add(const Duration(hours: 14)).millisecondsSinceEpoch,
      'progress': 40,
      'source': 'official',
      'is_planned': 0,
      'official_url': 'https://status.netia.pl/demo',
      'last_checked': now.millisecondsSinceEpoch,
      'nearby_reports_last_hour': 47,
      'local_streets': 'Grunwaldzka|Kościuszki',
      'all_streets': 'Grunwaldzka|Kościuszki|Ślężna|Powstańców|Hallera',
      'distressing_note': null,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
    target.insert('service_outages', {
      'service_id': 'veolia',
      'cause': 'Planowana konserwacja sieci wodociągowej',
      'window_start': tomorrow.add(const Duration(hours: 8)).millisecondsSinceEpoch,
      'window_end': tomorrow.add(const Duration(hours: 16)).millisecondsSinceEpoch,
      'eta': tomorrow.add(const Duration(hours: 16)).millisecondsSinceEpoch,
      'progress': 0,
      'source': 'official',
      'is_planned': 1,
      'official_url': 'https://www.veolia.pl/demo',
      'last_checked': now.millisecondsSinceEpoch,
      'nearby_reports_last_hour': 3,
      'local_streets': 'Szarych Szeregów',
      'all_streets': 'Szarych Szeregów|Wrocławska|Częstochowska',
      'distressing_note': null,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
    target.insert('service_outages', {
      'service_id': 'openai',
      'cause': 'Wydłużony czas odpowiedzi API w regionie EU',
      'window_start': today.add(const Duration(hours: 9)).millisecondsSinceEpoch,
      'window_end': today.add(const Duration(hours: 18)).millisecondsSinceEpoch,
      'eta': today.add(const Duration(hours: 13)).millisecondsSinceEpoch,
      'progress': 70,
      'source': 'community',
      'is_planned': 0,
      'official_url': null,
      'last_checked': now.millisecondsSinceEpoch,
      'nearby_reports_last_hour': 8,
      'local_streets': 'lokalne zgłoszenia',
      'all_streets': 'lokalne zgłoszenia|cały region EU',
      'distressing_note': null,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);

    const netiaCounts = <int>[2, 5, 4, 8, 12, 20, 47];
    const veoliaCounts = <int>[0, 0, 1, 0, 0, 2, 3];
    const openaiCounts = <int>[1, 2, 2, 3, 4, 6, 8];
    _seedReportPoints(target, 'netia', today, netiaCounts);
    _seedReportPoints(target, 'veolia', today, veoliaCounts);
    _seedReportPoints(target, 'openai', today, openaiCounts);

    if (batch == null) {
      await target.commit(noResult: true);
    }
  }

  void _seedReportPoints(
    Batch batch,
    String serviceId,
    DateTime today,
    List<int> counts,
  ) {
    for (var index = 0; index < counts.length; index++) {
      final day = today.subtract(Duration(days: counts.length - 1 - index));
      batch.insert(
        'service_report_points',
        {
          'service_id': serviceId,
          'day': day.millisecondsSinceEpoch,
          'count': counts[index],
        },
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
  }
}
