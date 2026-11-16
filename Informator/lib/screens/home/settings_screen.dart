import 'package:material_ui/material_ui.dart';
import 'package:informator/generated/l10n.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Center(
      child: Text(
        S.of(context).settings,
        style: TextStyle(color: theme.onSurface, fontSize: 20),
      ),
    );
  }
}
