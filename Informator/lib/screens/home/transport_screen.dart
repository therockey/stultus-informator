import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:informator/generated/l10n.dart';
import 'package:informator/models/transport.dart';
import 'package:informator/providers/transport_provider.dart';
import 'package:informator/providers/app_bar_title_provider.dart';
import 'package:informator/screens/home/transport_line_details_screen.dart';
import 'package:informator/widgets/transport_line_card.dart';
import 'package:informator/widgets/transport_map.dart';
import 'package:material_ui/material_ui.dart';

/// Public transport overview: a schematic network map and the list of lines.
class TransportScreen extends ConsumerStatefulWidget {
  const TransportScreen({super.key, this.onLineTap});

  final ValueChanged<TransportLine>? onLineTap;

  @override
  ConsumerState<TransportScreen> createState() => _TransportScreenState();
}

class _TransportScreenState extends ConsumerState<TransportScreen> {
  String? _title;

  void _openLine(BuildContext context, TransportLine line) {
    if (widget.onLineTap != null) {
      widget.onLineTap!(line);
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => TransportLineDetailsScreen(lineId: line.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final strings = S.of(context);
    final linesState = ref.watch(transportLinesProvider);
    final title = strings.transport_title;
    if (_title != title) {
      _title = title;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ref.read(appBarTitleOverrideProvider.notifier).setTitle(title);
        }
      });
    }

    return Scaffold(
      body: linesState.when(
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
        data: (lines) => ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          children: [
            _SectionTitle(strings.transport_map_title),
            const SizedBox(height: 8),
            TransportMap(lines: lines, height: 200),
            const SizedBox(height: 20),
            _SectionTitle(strings.transport_lines_title),
            const SizedBox(height: 8),
            if (lines.isEmpty)
              Text(
                strings.transport_lines_empty,
                style: TextStyle(color: theme.onSurfaceVariant, fontSize: 16),
              )
            else
              for (var index = 0; index < lines.length; index++) ...[
                if (index > 0) const SizedBox(height: 12),
                TransportLineCard(
                  line: lines[index],
                  onOpen: () => _openLine(context, lines[index]),
                ),
              ],
          ],
        ),
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
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );
  }
}
