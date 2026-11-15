import 'package:material_ui/material_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:informator/screens/intro/page1.dart';

class IntroScreen extends ConsumerWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<PageViewModel> introPages = [
      Page1(context, ref),
    ];

    return IntroductionScreen(
      pages: introPages,
      showDoneButton: true,
      overrideDone: (con, fun) => TextButton(onPressed: null, child: Icon(Icons.arrow_forward, color: Colors.white)), // fake invisible button to prevent intro screen footer from changing size when 'next' button disappears
      showSkipButton: false,
      dotsContainerDecorator: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      globalBackgroundColor: Theme.of(context).colorScheme.onPrimary,
      next: const Icon(Icons.arrow_forward),
    );
  }
}
