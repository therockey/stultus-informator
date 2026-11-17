
import 'package:material_ui/material_ui.dart';

class ThankYouDialog extends StatelessWidget {
  const ThankYouDialog({super.key});

  @override
  Widget build(BuildContext context) {
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
                'Dziękujemy!',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(height: 20),
              Text(
                'Dziękujemy za odpowiedź!',
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
