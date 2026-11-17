
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:informator/generated/l10n.dart';
import 'package:informator/models/group.dart';
import 'package:informator/models/service.dart';
import 'package:informator/providers/services_provider.dart';
import 'package:informator/widgets/report_issue_dialog.dart';
import 'package:informator/widgets/service_card.dart';
import 'package:informator/widgets/thank_you_dialog.dart';
import 'package:material_ui/material_ui.dart';

class GroupDetailsScreen extends ConsumerWidget {
  const GroupDetailsScreen({
    super.key,
    required this.group,
  });

  final Group group;

  Future<void> _reportOutage(
    BuildContext context,
    Service service,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => const ReportIssueDialog(),
    );

    if (!context.mounted || confirmed != true) {
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (context) => const ThankYouDialog(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).colorScheme;
    final strings = S.of(context);
    final servicesState = ref.watch(servicesProvider);

    if (servicesState.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (servicesState.hasError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            strings.group_details_load_error(
              servicesState.error.toString(),
            ),
            style: TextStyle(color: theme.error),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final allServices = servicesState.requireValue;

    final groupServices = allServices
        .where((service) => service.groups.contains(group.name))
        .toList(growable: false);

    if (groupServices.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            strings.group_details_empty,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: theme.onSurfaceVariant,
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      itemCount: groupServices.length,
      separatorBuilder: (context, index) {
        return const SizedBox(height: 14);
      },
      itemBuilder: (context, index) {
        final service = groupServices[index];

        return ServiceCard(
          service: service,
          onReportOutage: () {
            _reportOutage(context, service);
          },
          onAddToGroup: null,
        );
      },
    );
  }
}
