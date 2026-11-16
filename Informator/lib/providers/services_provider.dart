import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:informator/models/service.dart';
import 'package:informator/providers/database_provider.dart';

final servicesProvider = FutureProvider<List<Service>>(
  (ref) => ref.watch(informatorRepositoryProvider).fetchServices(),
);
