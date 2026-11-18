import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:informator/models/service_details.dart';
import 'package:informator/providers/database_provider.dart';

final serviceDetailsProvider = FutureProvider.family<ServiceDetails, String>(
  (ref, serviceId) =>
      ref.watch(informatorRepositoryProvider).fetchServiceDetails(serviceId),
);
