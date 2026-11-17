import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:informator/models/group.dart';
import 'package:informator/providers/database_provider.dart';

final groupsProvider = AsyncNotifierProvider<GroupsNotifier, List<Group>>(
  GroupsNotifier.new,
);

class GroupsNotifier extends AsyncNotifier<List<Group>> {
  @override
  Future<List<Group>> build() {
    return ref.watch(informatorRepositoryProvider).fetchGroups();
  }

  Future<void> setNotificationsEnabled(String groupId, bool enabled) async {
    final groups = state.requireValue;
    state = AsyncData([
      for (final group in groups)
        group.id == groupId
            ? group.copyWith(notificationsEnabled: enabled)
            : group,
    ]);
    await ref
        .read(informatorRepositoryProvider)
        .updateGroupNotifications(groupId, enabled);
  }

  Future<void> remove(String groupId) async {
    state = AsyncData([
      for (final group in state.requireValue)
        if (group.id != groupId) group,
    ]);
    await ref.read(informatorRepositoryProvider).deleteGroup(groupId);
  }

  Future<void> add(String name) async {
  final group = await ref
      .read(informatorRepositoryProvider)
      .createGroup(name);

  state = AsyncData([
    ...state.requireValue,
    group,
  ]);
}
}
