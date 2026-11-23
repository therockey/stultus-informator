import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:informator/generated/l10n.dart';
import 'package:informator/models/notification_preferences.dart';
import 'package:informator/providers/user_settings_provider.dart';
import 'package:informator/widgets/glossary_sheet.dart';
import 'package:informator/widgets/language_settings_dialog.dart';
import 'package:informator/widgets/theme_settings_dialog.dart';
import 'package:material_ui/material_ui.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).colorScheme;
    final strings = S.of(context);
    final settings = ref.watch(userSettingsProvider).settings;
    final notifier = ref.read(userSettingsProvider);

    return Scrollbar(
      thumbVisibility: true,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        children: [
          _SectionTitle(strings.settings_section_appearance),
          ListTile(
            contentPadding: EdgeInsets.zero,
            minVerticalPadding: 12,
            leading: const Icon(Icons.language),
            title: Text(strings.settings_change_language),
            onTap: () => showDialog<void>(
              context: context,
              builder: (_) => const LanguageSettingsDialog(),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            minVerticalPadding: 12,
            leading: const Icon(Icons.brightness_6),
            title: Text(strings.settings_change_theme),
            onTap: () => showDialog<void>(
              context: context,
              builder: (_) => const ThemeSettingsDialog(),
            ),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(strings.settings_high_contrast),
            value: settings.highContrast,
            onChanged: notifier.setHighContrast,
          ),
          const SizedBox(height: 8),
          Text(
            strings.settings_text_size,
            style: TextStyle(
              color: theme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          Slider(
            value: UserSettingsNotifier.textScaleOptions
                .indexOf(settings.textScale)
                .clamp(0, 2)
                .toDouble(),
            min: 0,
            max: 2,
            divisions: 2,
            label: _textScaleLabel(strings, settings.textScale),
            onChanged: (value) {
              notifier.setTextScale(
                UserSettingsNotifier.textScaleOptions[value.round()],
              );
            },
          ),
          Text(
            _textScaleLabel(strings, settings.textScale),
            style: TextStyle(color: theme.onSurfaceVariant, fontSize: 12),
          ),
          const SizedBox(height: 16),
          _SectionTitle(strings.settings_section_accessibility),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(strings.settings_simplified_mode),
            subtitle: Text(strings.settings_simplified_mode_subtitle),
            value: settings.simplifiedMode,
            onChanged: notifier.setSimplifiedMode,
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(strings.settings_hide_distressing),
            subtitle: Text(strings.settings_hide_distressing_subtitle),
            value: settings.hideDistressing,
            onChanged: notifier.setHideDistressing,
          ),
          const SizedBox(height: 16),
          _SectionTitle(strings.settings_section_notifications),
          const SizedBox(height: 8),
          Text(
            strings.settings_channel,
            style: TextStyle(color: theme.onSurfaceVariant, fontSize: 13),
          ),
          const SizedBox(height: 8),
          SegmentedButton<NotificationChannel>(
            key: const Key('settings-channel'),
            segments: [
              ButtonSegment(
                value: NotificationChannel.push,
                label: Text(strings.settings_channel_push),
              ),
              ButtonSegment(
                value: NotificationChannel.sms,
                label: Text(strings.settings_channel_sms),
              ),
            ],
            selected: {settings.channel},
            onSelectionChanged: (selection) {
              notifier.setChannel(selection.first);
            },
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(strings.settings_quiet_hours),
            subtitle: Text(strings.settings_quiet_hours_subtitle),
            value: settings.quietHoursEnabled,
            onChanged: (enabled) {
              if (enabled) {
                notifier.setQuietHours(
                  startMinutes: const TimeOfDay(
                    hour: 22,
                    minute: 0,
                  ).toMinutes(),
                  endMinutes: const TimeOfDay(hour: 7, minute: 0).toMinutes(),
                );
              } else {
                notifier.clearQuietHours();
              }
            },
          ),
          if (settings.quietHoursEnabled) ...[
            ListTile(
              contentPadding: EdgeInsets.zero,
              minVerticalPadding: 12,
              title: Text(strings.settings_quiet_hours_start),
              trailing: Text(
                _formatMinutes(context, settings.quietHoursStart!),
              ),
              onTap: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDayExtension.fromMinutes(
                    settings.quietHoursStart!,
                  ),
                );
                if (picked == null) {
                  return;
                }
                await notifier.setQuietHours(
                  startMinutes: picked.toMinutes(),
                  endMinutes: settings.quietHoursEnd!,
                );
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              minVerticalPadding: 12,
              title: Text(strings.settings_quiet_hours_end),
              trailing: Text(_formatMinutes(context, settings.quietHoursEnd!)),
              onTap: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDayExtension.fromMinutes(
                    settings.quietHoursEnd!,
                  ),
                );
                if (picked == null) {
                  return;
                }
                await notifier.setQuietHours(
                  startMinutes: settings.quietHoursStart!,
                  endMinutes: picked.toMinutes(),
                );
              },
            ),
          ],
          const SizedBox(height: 16),
          _SectionTitle(strings.settings_section_glossary),
          ListTile(
            contentPadding: EdgeInsets.zero,
            minVerticalPadding: 12,
            leading: const Icon(Icons.menu_book_outlined),
            title: Text(strings.settings_glossary_open),
            onTap: () => showGlossarySheet(context),
          ),
          const SizedBox(height: 12),
          Center(
            child: TextButton(
              onPressed: () => Navigator.of(context).pushNamed('/license'),
              child: Text(
                strings.settings_licenses,
                style: const TextStyle(decoration: TextDecoration.underline),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _textScaleLabel(S strings, double scale) {
    if (scale >= 1.3) {
      return strings.settings_text_size_xlarge;
    }
    if (scale >= 1.15) {
      return strings.settings_text_size_large;
    }
    return strings.settings_text_size_normal;
  }

  String _formatMinutes(BuildContext context, int minutes) {
    return TimeOfDayExtension.fromMinutes(minutes).format(context);
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4, top: 8),
      child: Text(
        label,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: 14,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

extension TimeOfDayExtension on TimeOfDay {
  int toMinutes() => hour * 60 + minute;

  static TimeOfDay fromMinutes(int minutes) {
    final wrapped = minutes % (24 * 60);
    return TimeOfDay(hour: wrapped ~/ 60, minute: wrapped % 60);
  }
}
