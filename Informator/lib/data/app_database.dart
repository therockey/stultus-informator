import 'dart:io';
import 'dart:math';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  AppDatabase._([this._databasePath]);

  static final AppDatabase instance = AppDatabase._();

  static const _databaseName = 'informator.db';
  static const _databaseVersion = 2;

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

    await _seed(database);
  }

  Future<void> _upgradeDatabase(
    Database database,
    int oldVersion,
    int newVersion,
  ) async {
    if (oldVersion < 2) {
      await database.execute('''
        CREATE TABLE service_groups (
          service_id TEXT NOT NULL,
          name TEXT NOT NULL,
          position INTEGER NOT NULL,
          PRIMARY KEY (service_id, name),
          FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE CASCADE
        )
      ''');
      await _seedServiceGroups(database);
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
        target.insert('service_groups', {
          'service_id': entry.key,
          'name': entry.value[index],
          'position': index,
        });
      }
    }
    if (batch == null) {
      await target.commit(noResult: true);
    }
  }
}
