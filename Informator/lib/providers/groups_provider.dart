import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:informator/models/group.dart';

/// Groups the user belongs to.
const List<Group> initialGroups = <Group>[
  Group(id: 'moja-grupa', name: 'Twoja Grupa'),
  Group(
    id: 'dom',
    name: 'Dom',
    location: 'Szarych Szeregów 2, Kalisz',
    notificationsEnabled: true,
  ),
  Group(
    id: 'politechnika',
    name: 'Politechnika',
    location: 'Grunwaldzka 15, Wrocław',
    notificationsEnabled: true,
  ),
];

final groupsProvider = NotifierProvider<GroupsNotifier, List<Group>>(
  GroupsNotifier.new,
);

class GroupsNotifier extends Notifier<List<Group>> {
  @override
  List<Group> build() => initialGroups;

  void setNotificationsEnabled(String groupId, bool enabled) {
    state = [
      for (final group in state)
        group.id == groupId
            ? group.copyWith(notificationsEnabled: enabled)
            : group,
    ];
  }

  void remove(String groupId) {
    state = state.where((group) => group.id != groupId).toList(growable: false);
  }
}
