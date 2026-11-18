import 'package:material_ui/material_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:informator/screens/intro/page1.dart';
import 'package:informator/screens/intro/page2.dart';
import 'package:informator/screens/intro/page3.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        showSkipButton: true,
        skip: const Text('Pomiń'),
        done: const Icon(Icons.arrow_forward),
        onSkip: () => _finishIntro(context),
        onDone: () => _finishIntro(context),
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

Future<void> _finishIntro(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isFirstRun', false);
  if (context.mounted) {
    Navigator.of(context).pushReplacementNamed('/home');
  }
}
