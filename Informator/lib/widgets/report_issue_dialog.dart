
import 'package:informator/generated/l10n.dart';
import 'package:material_ui/material_ui.dart';

class ReportIssueDialog extends StatelessWidget {
  const ReportIssueDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);

    return AlertDialog(
      title: Text(strings.report_issue_title),
      content: Text(strings.report_issue_question),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(strings.common_no),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(strings.common_yes),
        ),
      ],
    );
  }
}
