import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:informator/generated/l10n.dart';
import 'package:informator/models/service_details.dart';
import 'package:informator/models/transport.dart';
import 'package:informator/providers/transport_provider.dart';
import 'package:informator/providers/app_bar_title_provider.dart';
import 'package:informator/providers/user_settings_provider.dart';
import 'package:informator/widgets/service_status.dart';
import 'package:informator/widgets/transport_delay_chart.dart';
import 'package:informator/widgets/transport_map.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

/// Warning details for one transport line: status, cause, detours, affected
/// area on the map and the delay history.
class TransportLineDetailsScreen extends ConsumerStatefulWidget {
  const TransportLineDetailsScreen({super.key, required this.lineId});

  final String lineId;

  @override
  ConsumerState<TransportLineDetailsScreen> createState() =>
      _TransportLineDetailsScreenState();
}

class _TransportLineDetailsScreenState
    extends ConsumerState<TransportLineDetailsScreen> {
  String? _title;

  @override
  Widget build(BuildContext context) {
    final details = ref.watch(transportLineDetailsProvider(widget.lineId));
    final settings = ref.watch(userSettingsProvider).settings;
    final strings = S.of(context);
    final title = details.maybeWhen(
      data: (value) => value.line.name,
      orElse: () => strings.transport_title,
    );
    if (_title != title) {
      _title = title;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ref.read(appBarTitleOverrideProvider.notifier).setTitle(title);
        }
      });
    }

    return Scaffold(
      body: details.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Text(
              strings.future_provider_error(error.toString()),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        data: (value) =>
            _Body(details: value, simplified: settings.simplifiedMode),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.details, required this.simplified});

  final TransportLineDetails details;

  final bool simplified;

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final theme = Theme.of(context).colorScheme;
    final line = details.line;
    final statusColor = kServiceStatusColors[line.status]!;
    final currentDelay = line.delays.isEmpty ? null : line.delays.last.minutes;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      children: [
        _StatusBanner(details: details),
        const SizedBox(height: 20),
        if (!line.hasOutage)
          Text(
            strings.service_operational_message,
            style: TextStyle(color: theme.onSurface, fontSize: 16),
          )
        else ...[
          if (!simplified && details.hasArea) ...[
            _SectionTitle(strings.transport_affected_area),
            const SizedBox(height: 8),
            TransportMap(
              lines: [line],
              areaX: details.areaX,
              areaY: details.areaY,
              areaRadius: details.areaRadius,
              height: 200,
            ),
            const SizedBox(height: 20),
          ],
          _Fact(label: strings.service_cause, value: details.cause ?? '—'),
          if (details.startedAt != null)
            _Fact(
              label: strings.transport_started,
              value: _formatDateTime(context, details.startedAt!),
            ),
          if (details.eta != null)
            _Fact(
              label: strings.service_eta,
              value: _formatDateTime(context, details.eta!),
            ),
          if (currentDelay != null)
            _Fact(
              label: strings.transport_current_delay,
              value: strings.transport_delay_minutes(currentDelay),
            ),
          if (details.source != null)
            _Fact(
              label: strings.service_source,
              value: details.source == OutageSource.community
                  ? strings.service_source_community
                  : strings.service_source_official,
            ),
          const SizedBox(height: 10),
          _DetoursCard(detours: details.detours),
        ],
        if (!simplified && line.delays.isNotEmpty) ...[
          const SizedBox(height: 20),
          _SectionTitle(strings.transport_delay_chart_title),
          const SizedBox(height: 8),
          TransportDelayChart(points: line.delays, color: statusColor),
        ],
      ],
    );
  }
}

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({required this.details});

  final TransportLineDetails details;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final strings = S.of(context);
    final line = details.line;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ServiceStatusBadge(status: line.status, size: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        strings.transport_status(
                          serviceStatusLabel(strings, line.status),
                        ),
                        style: TextStyle(
                          color: theme.onSurface,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (line.hasOutage) ...[
                      const SizedBox(width: 8),
                      Icon(
                        Icons.warning_amber_rounded,
                        color: kServiceStatusColors[line.status],
                      ),
                    ],
                  ],
                ),
                if (details.lastChecked != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    strings.service_last_checked(
                      _formatDateTime(context, details.lastChecked!),
                    ),
                    style: TextStyle(
                      color: theme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetoursCard extends StatelessWidget {
  const _DetoursCard({required this.detours});

  final List<TransportDetour> detours;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final strings = S.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            strings.transport_detours,
            style: TextStyle(
              color: theme.onSurface,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          if (detours.isEmpty)
            Text(
              strings.transport_detours_none,
              style: TextStyle(color: theme.onSurfaceVariant, fontSize: 14),
            )
          else
            for (final detour in detours)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(Icons.alt_route, size: 20, color: theme.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '${detour.fromLine} → ${detour.toLine}',
                        style: TextStyle(
                          color: theme.onSurface,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact({required this.label, required this.value});

  final String label;

  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: theme.onSurfaceVariant,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(value, style: TextStyle(color: theme.onSurface, fontSize: 16)),
        ],
      ),
    );
  }
}

String _formatDateTime(BuildContext context, DateTime value) {
  final locale = Localizations.localeOf(context).toString();
  return DateFormat.yMMMd(locale).add_Hm().format(value);
}
