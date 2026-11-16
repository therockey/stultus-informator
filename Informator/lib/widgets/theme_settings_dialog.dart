import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:informator/generated/l10n.dart';
import 'package:informator/providers/app_theme_provider.dart';
import 'package:material_ui/material_ui.dart';

class ThemeSettingsDialog extends ConsumerWidget {
  const ThemeSettingsDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.watch(themeProvider);
    final strings = S.of(context);

    return AlertDialog(
      title: Text(strings.themedialog_title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ThemeOption(
            title: strings.themedialog_system,
            mode: AppThemeMode.system,
            selected: themeNotifier.theme == AppThemeMode.system,
          ),
          _ThemeOption(
            title: strings.themedialog_light,
            mode: AppThemeMode.light,
            selected: themeNotifier.theme == AppThemeMode.light,
          ),
          _ThemeOption(
            title: strings.themedialog_dark,
            mode: AppThemeMode.dark,
            selected: themeNotifier.theme == AppThemeMode.dark,
          ),
        ],
      ),
    );
  }
}

class _ThemeOption extends ConsumerWidget {
  const _ThemeOption({
    required this.title,
    required this.mode,
    required this.selected,
  });

  final String title;
  final AppThemeMode mode;
  final bool selected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(title),
      trailing: selected ? const Icon(Icons.check) : null,
      onTap: () async {
        await ref.read(themeProvider).setTheme(mode);
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      },
    );
  }
}
