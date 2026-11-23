import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:informator/generated/l10n.dart';
import 'package:informator/models/group.dart';
import 'package:informator/providers/groups_provider.dart';
import 'package:informator/widgets/group_card.dart';
import 'package:material_ui/material_ui.dart';

class GroupsScreen extends ConsumerWidget {
  const GroupsScreen({super.key, this.onGroupTap});

  final ValueChanged<Group>? onGroupTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupsState = ref.watch(groupsProvider);
    final theme = Theme.of(context).colorScheme;

    if (groupsState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (groupsState.hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            groupsState.error.toString(),
            style: TextStyle(color: theme.error),
          ),
        ),
      );
    }

    final groups = groupsState.requireValue;

    if (groups.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            S.of(context).groups_empty,
            textAlign: TextAlign.center,
            style: TextStyle(color: theme.onSurfaceVariant, fontSize: 16),
          ),
        ),
      );
    }

    return Scrollbar(
      thumbVisibility: true,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 96),
        itemCount: groups.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final group = groups[index];

          return GroupCard(
            key: ValueKey(group.id),
            group: group,
            onTap: () {
              if (onGroupTap != null) {
                onGroupTap!(group);
              } else {
                Navigator.of(context)
                    .pushNamed('/groups/${Uri.encodeComponent(group.name)}');
              }
            },
            onNotificationsChanged: (enabled) {
              ref
                  .read(groupsProvider.notifier)
                  .setNotificationsEnabled(group.id, enabled);
            },
            onRemove: () {
              ref.read(groupsProvider.notifier).remove(group.id);
            },
          );
        },
      ),
    );
  }
}

class AddGroupButton extends StatelessWidget {
  const AddGroupButton({super.key, this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return FloatingActionButton.large(
      onPressed: onPressed,
      tooltip: S.of(context).groups_add,
      backgroundColor: theme.secondaryContainer,
      foregroundColor: theme.onSecondaryContainer,
      child: const Icon(Icons.add, size: 32),
    );
  }
}
