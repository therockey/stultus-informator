import 'package:informator/generated/l10n.dart';
import 'package:informator/models/group.dart';
import 'package:material_ui/material_ui.dart';

/// Bell colour used while outage notifications are turned on for a group.
const Color _notificationsOnColor = Color(0xFFCBA600);

/// One group on the groups list: notification state, name and location.
class GroupCard extends StatelessWidget {
  const GroupCard({
    super.key,
    required this.group,
    this.onNotificationsChanged,
    this.onRemove,
  });

  final Group group;

  final ValueChanged<bool>? onNotificationsChanged;

  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final strings = S.of(context);
    final location = group.location;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ExcludeSemantics(
                child: Icon(
                  Icons.notifications_none,
                  size: 24,
                  color: group.notificationsEnabled
                      ? _notificationsOnColor
                      : theme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 8),
              Semantics(
                label: strings.group_notifications_label,
                child: Switch(
                  value: group.notificationsEnabled,
                  onChanged: onNotificationsChanged,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: onRemove,
                tooltip: strings.group_remove,
                icon: const Icon(Icons.close, size: 20),
                color: theme.onSurfaceVariant,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            group.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: theme.onSurfaceVariant,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            strings.group_location(
              location ?? strings.group_location_none,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: theme.onSurfaceVariant,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
