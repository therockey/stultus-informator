import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:informator/models/service.dart';

/// Services shown before the user searches for a specific one.
const List<Service> popularServices = <Service>[
  Service(
    id: 'netia',
    name: 'Netia',
    status: ServiceStatus.outage,
    groups: <String>['Dom', 'Media'],
  ),
  Service(
    id: 'openai',
    name: 'OpenAI',
    status: ServiceStatus.degraded,
    groups: <String>['Serwis'],
  ),
  Service(
    id: 'grygry2',
    name: 'GryGry2',
    status: ServiceStatus.operational,
    groups: <String>['Gry', 'Serwis'],
  ),
  Service(
    id: 'tauron',
    name: 'Tauron',
    status: ServiceStatus.operational,
    groups: <String>['Dom'],
  ),
  Service(
    id: 'veolia',
    name: 'Veolia',
    status: ServiceStatus.outage,
    groups: <String>['Dom', 'Media'],
  ),
  Service(id: 'mpk', name: 'MPK Wrocław', status: ServiceStatus.operational),
];

final servicesProvider = Provider<List<Service>>((ref) => popularServices);
