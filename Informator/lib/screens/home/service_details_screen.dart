import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:informator/generated/l10n.dart';
import 'package:informator/models/notification_preferences.dart';
import 'package:informator/models/service_details.dart';
import 'package:informator/providers/database_provider.dart';
import 'package:informator/providers/app_bar_title_provider.dart';
import 'package:informator/providers/service_details_provider.dart';
import 'package:informator/providers/user_settings_provider.dart';
import 'package:informator/widgets/glossary_sheet.dart';
import 'package:informator/widgets/outage_heatmap.dart';
import 'package:informator/widgets/outage_reports_chart.dart';
import 'package:informator/widgets/service_status.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

class ServiceDetailsScreen extends ConsumerStatefulWidget {
  const ServiceDetailsScreen({super.key, required this.serviceId});

  final String serviceId;

  @override
  ConsumerState<ServiceDetailsScreen> createState() =>
      _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends ConsumerState<ServiceDetailsScreen> {
  bool _localView = true;
  String? _title;

  @override
  Widget build(BuildContext context) {
    final details = ref.watch(serviceDetailsProvider(widget.serviceId));
    final settings = ref.watch(userSettingsProvider).settings;
    final strings = S.of(context);
    final title = details.maybeWhen(
      data: (value) => value.service.name,
      orElse: () => strings.services,
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
        error: (error, _) => Center(child: Text(error.toString())),
        data: (value) => settings.simplifiedMode
            ? _SimplifiedBody(details: value)
            : _FullBody(
                details: value,
                hideDistressing: settings.hideDistressing,
                localView: _localView,
                onLocalViewChanged: (local) =>
                    setState(() => _localView = local),
                onNotificationsChanged: _updateNotifications,
              ),
      ),
    );
  }

  Future<void> _updateNotifications({
    bool? enabled,
    NotificationRule? rule,
    NotificationLeadTime? leadTime,
  }) async {
    await ref
        .read(informatorRepositoryProvider)
        .updateServiceNotifications(
          serviceId: widget.serviceId,
          enabled: enabled,
          rule: rule,
          leadTime: leadTime,
        );
    ref.invalidate(serviceDetailsProvider(widget.serviceId));
  }
}

class _SimplifiedBody extends StatelessWidget {
  const _SimplifiedBody({required this.details});

  final ServiceDetails details;

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final facts = <Widget>[
      _SimpleFact(
        icon: Icons.info_outline,
        label: serviceStatusLabel(strings, details.service.status),
      ),
      if (details.eta != null)
        _SimpleFact(
          icon: Icons.schedule,
          label: _formatDateTime(context, details.eta!),
        )
      else if (details.windowEnd != null)
        _SimpleFact(
          icon: Icons.schedule,
          label: _formatDateTime(context, details.windowEnd!),
        ),
      if (details.cause != null)
        _SimpleFact(icon: Icons.report_outlined, label: details.cause!),
    ].take(3).toList(growable: false);

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      children: [
        Column(
          key: const Key('simplified-info'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var index = 0; index < facts.length; index++) ...[
              if (index > 0) const SizedBox(height: 24),
              facts[index],
            ],
          ],
        ),
        const SizedBox(height: 32),
        TextButton(
          onPressed: () => showGlossarySheet(context),
          child: Text(strings.service_open_glossary),
        ),
      ],
    );
  }
}

class _SimpleFact extends StatelessWidget {
  const _SimpleFact({required this.icon, required this.label});

  final IconData icon;

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 36, color: theme.primary),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: theme.onSurface,
              fontSize: 22,
              fontWeight: FontWeight.w600,
              height: 1.25,
            ),
          ),
        ),
      ],
    );
  }
}

class _FullBody extends StatelessWidget {
  const _FullBody({
    required this.details,
    required this.hideDistressing,
    required this.localView,
    required this.onLocalViewChanged,
    required this.onNotificationsChanged,
  });

  final ServiceDetails details;

  final bool hideDistressing;

  final bool localView;

  final ValueChanged<bool> onLocalViewChanged;

  final Future<void> Function({
    bool? enabled,
    NotificationRule? rule,
    NotificationLeadTime? leadTime,
  })
  onNotificationsChanged;

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final theme = Theme.of(context).colorScheme;
    final service = details.service;
    final streets = localView ? details.localStreets : details.allStreets;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      children: [
        Row(
          children: [
            ServiceStatusBadge(status: service.status, size: 40),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.name,
                    style: TextStyle(
                      color: theme.onSurface,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        serviceStatusLabel(strings, service.status),
                        style: TextStyle(
                          color: theme.onSurface,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: () => showGlossarySheet(context),
                        child: Text(strings.service_open_glossary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        if (details.lastChecked != null) ...[
          const SizedBox(height: 4),
          Text(
            strings.service_last_checked(
              _formatDateTime(context, details.lastChecked!),
            ),
            style: TextStyle(color: theme.onSurfaceVariant, fontSize: 12),
          ),
        ],
        const SizedBox(height: 16),
        if (!details.hasOutage)
          Text(
            strings.service_operational_message,
            style: TextStyle(color: theme.onSurface, fontSize: 16),
          )
        else ...[
          _Fact(label: strings.service_cause, value: details.cause ?? '—'),
          if (details.windowStart != null && details.windowEnd != null)
            _Fact(
              label: strings.service_window,
              value: strings.service_window_value(
                _formatDateTime(context, details.windowStart!),
                _formatDateTime(context, details.windowEnd!),
              ),
            ),
          if (details.eta != null)
            _Fact(
              label: strings.service_eta,
              value: _formatDateTime(context, details.eta!),
            ),
          if (details.progress != null)
            _Fact(
              label: strings.service_progress,
              value: strings.service_progress_value(details.progress!),
            ),
          _Fact(
            label: strings.service_source,
            value: details.source == OutageSource.community
                ? strings.service_source_community
                : strings.service_source_official,
          ),
          _Fact(
            label: details.isPlanned
                ? strings.service_type_planned
                : strings.service_type_unplanned,
            value: '',
          ),
          Text(
            strings.service_reports_last_hour(details.nearbyReportsLastHour),
            style: TextStyle(
              color: theme.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (details.officialUrl != null) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        strings.service_official_link_stub(
                          details.officialUrl!,
                        ),
                      ),
                    ),
                  );
                },
                child: Text(strings.service_official_link),
              ),
            ),
          ],
          if (!hideDistressing && details.distressingNote != null) ...[
            const SizedBox(height: 8),
            Text(
              details.distressingNote!,
              style: TextStyle(color: theme.onSurfaceVariant, fontSize: 14),
            ),
          ],
        ],
        const SizedBox(height: 20),
        if (details.hasOutage && streets.isNotEmpty) ...[
          Text(
            strings.service_heatmap_title,
            style: TextStyle(
              color: theme.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            key: const Key('heatmap-scope'),
            spacing: 8,
            runSpacing: 8,
            children: [
              ChoiceChip(
                label: Text(strings.service_heatmap_local),
                selected: localView,
                onSelected: (_) => onLocalViewChanged(true),
              ),
              ChoiceChip(
                label: Text(strings.service_heatmap_all),
                selected: !localView,
                onSelected: (_) => onLocalViewChanged(false),
              ),
            ],
          ),
          const SizedBox(height: 8),
          OutageHeatmap(streets: streets),
          const SizedBox(height: 20),
        ],
        if (details.reportPoints.isNotEmpty) ...[
          Text(
            strings.service_chart_title,
            style: TextStyle(
              color: theme.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          OutageReportsChart(points: details.reportPoints),
          const SizedBox(height: 20),
        ],
        SwitchListTile(
          key: const Key('service-notifications-switch'),
          contentPadding: EdgeInsets.zero,
          title: Text(strings.service_notifications),
          value: details.notifications.enabled,
          onChanged: (value) => onNotificationsChanged(enabled: value),
        ),
        const SizedBox(height: 8),
        Text(
          strings.service_rule,
          style: TextStyle(color: theme.onSurfaceVariant, fontSize: 13),
        ),
        const SizedBox(height: 8),
        Wrap(
          key: const Key('service-notification-rule'),
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final option in NotificationRule.values)
              ChoiceChip(
                label: Text(_ruleLabel(strings, option)),
                selected: details.notifications.rule == option,
                onSelected: (_) => onNotificationsChanged(rule: option),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          strings.service_lead_time,
          style: TextStyle(color: theme.onSurfaceVariant, fontSize: 13),
        ),
        const SizedBox(height: 8),
        Wrap(
          key: const Key('service-lead-time'),
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final option in NotificationLeadTime.values)
              ChoiceChip(
                label: Text(_leadLabel(strings, option)),
                selected: details.notifications.leadTime == option,
                onSelected: (_) => onNotificationsChanged(leadTime: option),
              ),
          ],
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(strings.service_report_stub)),
            );
          },
          icon: const Icon(Icons.warning_amber_rounded),
          label: Text(strings.service_report_outage),
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(strings.service_history_stub)),
            );
          },
          child: Text(strings.service_history),
        ),
      ],
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
          if (value.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(value, style: TextStyle(color: theme.onSurface, fontSize: 16)),
          ],
        ],
      ),
    );
  }
}

String _formatDateTime(BuildContext context, DateTime value) {
  final locale = Localizations.localeOf(context).toString();
  return DateFormat.yMMMd(locale).add_Hm().format(value);
}

String _ruleLabel(S strings, NotificationRule rule) {
  return switch (rule) {
    NotificationRule.all => strings.service_rule_all,
    NotificationRule.plannedOnly => strings.service_rule_planned,
    NotificationRule.outagesOnly => strings.service_rule_outages,
  };
}

String _leadLabel(S strings, NotificationLeadTime leadTime) {
  return switch (leadTime) {
    NotificationLeadTime.none => strings.service_lead_none,
    NotificationLeadTime.twoHours => strings.service_lead_two_hours,
    NotificationLeadTime.oneDay => strings.service_lead_one_day,
  };
}
