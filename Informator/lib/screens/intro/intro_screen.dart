import 'package:material_ui/material_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:informator/screens/intro/page1.dart';
import 'package:informator/screens/intro/page2.dart';
import 'package:informator/screens/intro/page3.dart';
import 'package:informator/generated/l10n.dart';
import 'package:informator/providers/intro_step_provider.dart';

class IntroScreen extends ConsumerStatefulWidget {
  const IntroScreen({super.key});

  @override
  ConsumerState<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends ConsumerState<IntroScreen> {
  final GlobalKey<IntroductionScreenState> _introKey =
      GlobalKey<IntroductionScreenState>();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final setupStep = ref
        .watch(currentStepProvider)
        .maybeWhen(data: (step) => step, orElse: () => 0);
    final permissionsComplete = setupStep == 4;
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
        key: _introKey,
        pages: introPages,
        showDoneButton: _currentPage == 2 && permissionsComplete,
        showSkipButton: true,
        skip: Text(S.of(context).intro_skip),
        done: Text(S.of(context).intropage3_step2),
        onSkip: () => _skipToPermissions(context),
        onDone: () => _finishIntro(context),
        onChange: (page) => setState(() => _currentPage = page),
        showNextButton: _currentPage < 2,
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

  Future<void> _skipToPermissions(BuildContext context) async {
    await _introKey.currentState?.animateScroll(2);
    if (!mounted) return;

    final step = await ref.read(currentStepProvider.future);
    if (!mounted) return;

    final permission = switch (step) {
      1 => Permission.notification,
      2 => Permission.locationWhenInUse,
      3 => Permission.ignoreBatteryOptimizations,
      _ => null,
    };

    if (permission != null) {
      try {
        await permission.request();
      } on Exception {
        // Desktop and unsupported platforms have no permission channel.
      }
      ref.invalidate(currentStepProvider);
    }
  }
}

Future<void> _finishIntro(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isFirstRun', false);
  if (context.mounted) {
    Navigator.of(context).pushReplacementNamed('/home');
  }
}
