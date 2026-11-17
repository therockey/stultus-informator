import 'package:material_ui/material_ui.dart';

class ReportIssueDialog extends StatelessWidget {
  const ReportIssueDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Zgłoś problem'),
      content: const Text(
        'Czy doświadczasz problemów z tą usługą?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Nie'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Tak'),
        ),
      ],
    );
  }
}