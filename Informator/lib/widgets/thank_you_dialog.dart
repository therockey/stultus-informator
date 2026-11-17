
import 'package:informator/generated/l10n.dart';
import 'package:material_ui/material_ui.dart';

class ThankYouDialog extends StatelessWidget {
  const ThankYouDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = S.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      child: SizedBox(
        width: 350,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 28, 28, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                strings.thank_you_title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 20),
              Text(
                strings.thank_you_message,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 28),
              const Center(
                child: Text(
                  '👍',
                  style: TextStyle(fontSize: 48),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
