import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:informator/data/app_database.dart';
import 'package:informator/data/informator_repository.dart';

final databaseProvider = Provider<AppDatabase>((ref) => AppDatabase.instance);

final informatorRepositoryProvider = Provider<InformatorRepository>(
  (ref) => InformatorRepository(ref.watch(databaseProvider)),
);
