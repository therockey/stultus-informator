import 'package:informator/generated/l10n.dart';
import 'package:material_ui/material_ui.dart';

Future<void> showGlossarySheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (context) => const GlossarySheet(),
  );
}

/// FR-8.4: awaria / konserwacja / problem lokalny, reachable from status and settings.
class GlossarySheet extends StatelessWidget {
  const GlossarySheet({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);
    final theme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              strings.glossary_title,
              style: TextStyle(
                color: theme.onSurface,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            _Entry(
              term: strings.glossary_outage_term,
              body: strings.glossary_outage_body,
            ),
            const SizedBox(height: 12),
            _Entry(
              term: strings.glossary_maintenance_term,
              body: strings.glossary_maintenance_body,
            ),
            const SizedBox(height: 12),
            _Entry(
              term: strings.glossary_local_term,
              body: strings.glossary_local_body,
            ),
          ],
        ),
      ),
    );
  }
}

class _Entry extends StatelessWidget {
  const _Entry({required this.term, required this.body});

  final String term;

  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          term,
          style: TextStyle(
            color: theme.onSurface,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          body,
          style: TextStyle(color: theme.onSurfaceVariant, fontSize: 14, height: 1.4),
        ),
      ],
    );
  }
}
