import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:informator/models/transport.dart';
import 'package:informator/providers/database_provider.dart';

final transportLinesProvider = FutureProvider<List<TransportLine>>(
  (ref) => ref.watch(informatorRepositoryProvider).fetchTransportLines(),
);

final transportLineDetailsProvider =
    FutureProvider.family<TransportLineDetails, String>(
      (ref, lineId) => ref
          .watch(informatorRepositoryProvider)
          .fetchTransportLineDetails(lineId),
    );
