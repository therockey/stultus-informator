import 'package:material_ui/material_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:informator/screens/intro/page1.dart';
import 'package:informator/screens/intro/page2.dart';
import 'package:informator/screens/intro/page3.dart';

class IntroScreen extends ConsumerWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<PageViewModel> introPages = [
      Page1(context, ref),
      Page2(context, ref),
      Page3(context, ref),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Welcome to Informator',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: IntroductionScreen(
        pages: introPages,
        showDoneButton: true,
        overrideDone: (con, fun) => TextButton(
          onPressed: null,
          child: Icon(Icons.arrow_forward, color: Colors.white),
        ),
        // fake invisible button to prevent intro screen footer from changing size when 'next' button disappears
        showSkipButton: false,
        dotsDecorator: DotsDecorator(
          activeColor: Theme.of(context).colorScheme.onPrimaryContainer,
          color: Theme.of(context).colorScheme.onPrimaryContainer
              .withValues(alpha: 0.5),
        ),
        dotsContainerDecorator: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        globalBackgroundColor: Theme.of(context).colorScheme.surface,
        next: const Icon(Icons.arrow_forward),
      ),
    );
  }
}
