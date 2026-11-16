import 'package:material_ui/material_ui.dart';
import 'package:informator/generated/l10n.dart';
import 'package:informator/widgets/language_settings_dialog.dart';
import 'package:informator/widgets/theme_settings_dialog.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 520,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: theme.outlineVariant),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              S.of(context).settings_placeholder,
              style: TextStyle(color: theme.onSurfaceVariant, fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          Divider(color: theme.outlineVariant),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => showDialog<void>(
                    context: context,
                    builder: (_) => const LanguageSettingsDialog(),
                  ),
                  icon: const Icon(Icons.language),
                  label: Text(S.of(context).settings_change_language),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => showDialog<void>(
                    context: context,
                    builder: (_) => const ThemeSettingsDialog(),
                  ),
                  icon: const Icon(Icons.brightness_6),
                  label: Text(S.of(context).settings_change_theme),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Center(
            child: TextButton(
              onPressed: () => Navigator.of(context).pushNamed('/license'),
              child: Text(
                S.of(context).settings_licenses,
                style: const TextStyle(decoration: TextDecoration.underline),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
