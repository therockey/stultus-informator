import 'package:material_ui/material_ui.dart';
import 'package:informator/generated/l10n.dart';

class GroupsScreen extends StatelessWidget {
  const GroupsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Center(
      child: Text(
        S.of(context).groups,
        style: TextStyle(color: theme.onSurface, fontSize: 20),
      ),
    );
  }
}
