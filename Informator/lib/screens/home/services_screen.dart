
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:informator/generated/l10n.dart';
import 'package:informator/models/group.dart';
import 'package:informator/models/service.dart';
import 'package:informator/providers/database_provider.dart';
import 'package:informator/providers/groups_provider.dart';
import 'package:informator/providers/services_provider.dart';
import 'package:informator/widgets/add_to_group_dialog.dart';
import 'package:informator/widgets/report_issue_dialog.dart';
import 'package:informator/widgets/thank_you_dialog.dart';
import 'package:informator/widgets/service_card.dart';
import 'package:material_ui/material_ui.dart';

/// Lists popular services and lets the user search the catalogue by name.
class ServicesScreen extends ConsumerStatefulWidget {
  const ServicesScreen({super.key});

  @override
  ConsumerState<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends ConsumerState<ServicesScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _query = '';

  Future<void> _showAddToGroupDialog(Service service) async {
    try {
      final groups = await ref.read(groupsProvider.future);

      if (!mounted) return;

      final selectedGroup = await showDialog<Group>(
        context: context,
        builder: (context) => AddToGroupDialog(
          groups: groups,
        ),
      );

      if (selectedGroup == null || !mounted) return;

      await ref
          .read(informatorRepositoryProvider)
          .addServiceToGroup(service.id, selectedGroup.name);

      ref.invalidate(servicesProvider);
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).services_add_to_group_error(error.toString()),
),
        ),
      );
    }
  }

  Future<void> _showReportIssueDialog(Service service) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => const ReportIssueDialog(),
    );

    if (!mounted || confirmed != true) return;

    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) => const ThankYouDialog(),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    setState(() => _query = value);
  }

  void _clearQuery() {
    _searchController.clear();
    _onQueryChanged('');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final strings = S.of(context);
    final servicesState = ref.watch(servicesProvider);
    if (servicesState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (servicesState.hasError) {
      return _LoadError(message: servicesState.error.toString());
    }
    final services = servicesState.requireValue;
    final List<Service> results = services
        .where((service) => service.matchesQuery(_query))
        .toList(growable: false);
    final isSearching = _query.trim().isNotEmpty;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: _SearchField(
            controller: _searchController,
            hintText: strings.services_search_hint,
            showClearButton: _query.isNotEmpty,
            onChanged: _onQueryChanged,
            onClear: _clearQuery,
          ),
        ),
        Expanded(
          child: results.isEmpty
              ? _NoResults(message: strings.services_no_results)
              : ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  children: [
                    if (!isSearching)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          strings.services_popular,
                          style: TextStyle(
                            color: theme.onSurfaceVariant,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    for (var index = 0; index < results.length; index++) ...[
                      if (index > 0) const SizedBox(height: 12),
                      ServiceCard(
                        service: results[index],
                        onReportOutage: () =>
                            _showReportIssueDialog(results[index]),
                        onAddToGroup: () =>
                            _showAddToGroupDialog(results[index]),
                      ),
                    ],
                  ],
                ),
        ),
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.hintText,
    required this.showClearButton,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  
  final String hintText;

  final bool showClearButton;

  final ValueChanged<String> onChanged;

  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(28),
      borderSide: BorderSide.none,
    );

    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
       style: TextStyle(color: theme.onSurface, fontSize: 16),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: theme.onSurfaceVariant, fontSize: 16),
        prefixIcon: Icon(Icons.search, color: theme.onSurfaceVariant),
        suffixIcon: showClearButton
            ? IconButton(
                onPressed: onClear,
                icon: const Icon(Icons.close),
                color: theme.onSurfaceVariant,
              )
            : null,
        filled: true,
        fillColor: theme.surfaceContainerHigh,
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: border,
        enabledBorder: border,
        focusedBorder: border,
      ),
    );
  }
}

class _NoResults extends StatelessWidget {
  const _NoResults({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(color: theme.onSurfaceVariant, fontSize: 16),
        ),
      ),
    );
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text(message, textAlign: TextAlign.center),
      ),
    );
  }
}
