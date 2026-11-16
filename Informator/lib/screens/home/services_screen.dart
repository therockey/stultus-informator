import 'package:material_ui/material_ui.dart';
import 'package:informator/generated/l10n.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Center(
      child: Text(
        S.of(context).services,
        style: TextStyle(color: theme.onSurface, fontSize: 20),
      ),
    );
  }
}
