import 'package:material_ui/material_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:informator/generated/l10n.dart';
import 'package:informator/providers/intro_step_provider.dart';

class Page3 extends PageViewModel {
  // ignore: unused_field
  final WidgetRef _ref;

  // ignore: unused_field
  final BuildContext _context;

  static const _titleStyle = TextStyle(
    fontSize: 28.0,
    fontWeight: FontWeight.w700,
  );

  Page3(this._context, this._ref)
    : super(
        titleWidget: Consumer(
          builder: (context, ref, child) {
            final strings = S.of(context);
            final title = ref
                .watch(currentStepProvider)
                .maybeWhen(
                  data: (step) => _titleForStep(context, step),
                  orElse: () => strings.intropage3_title,
                );

            return Text(title, textAlign: TextAlign.center, style: _titleStyle);
          },
        ),
        image: Consumer(
          builder: (context, ref, child) {
            final icon = ref
                .watch(currentStepProvider)
                .maybeWhen(
                  data: (step) => switch (step) {
                    1 => Icons.notifications_active,
                    2 => Icons.location_on,
                    3 => Icons.battery_alert,
                    _ => Icons.check_circle,
                  },
                  orElse: () => Icons.notifications_active,
                );

            return Center(
              child: Icon(
                icon,
                size: 140,
                color: Theme.of(context).colorScheme.primary,
                semanticLabel: S.of(context).intropage3_semantics,
              ),
            );
          },
        ),
        bodyWidget: Consumer(
          builder: (context, ref, child) {
            final step = ref.watch(currentStepProvider);

            return step.when(
              data: (currentStep) => _buildStep(context, ref, currentStep),
              loading: () => const Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
              error: (error, stackTrace) => Text(
                S.of(context).future_provider_error(error.toString()),
                textAlign: TextAlign.center,
              ),
            );
          },
        ),
        decoration: PageDecoration(
          imagePadding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          imageAlignment: Alignment.center,
          titleTextStyle: _titleStyle,
          pageColor: Theme.of(_context).colorScheme.surface,
        ),
      );

  static String _titleForStep(BuildContext context, int step) {
    final strings = S.of(context);

    return switch (step) {
      1 => strings.intropage3_notifications_title,
      2 => strings.intropage3_location_title,
      3 => strings.intropage3_battery_title,
      _ => strings.intropage3_done_title,
    };
  }

  static Widget _buildStep(
    BuildContext context,
    WidgetRef ref,
    int currentStep,
  ) {
    final strings = S.of(context);

    return switch (currentStep) {
      1 => _buildStepLayout(
        context,
        body: strings.intropage3_notifications_body,
        buttonLabel: strings.intropage3_notifications_step,
        onPressed: () async {
          await Permission.notification.request();
          ref.invalidate(currentStepProvider);
        },
        onRecheck: () => ref.invalidate(currentStepProvider),
      ),
      2 => _buildStepLayout(
        context,
        body: strings.intropage3_location_body,
        buttonLabel: strings.intropage3_location_step,
        onPressed: () async {
          await Permission.locationWhenInUse.request();
          ref.invalidate(currentStepProvider);
        },
        onRecheck: () => ref.invalidate(currentStepProvider),
      ),
      3 => _buildStepLayout(
        context,
        body: strings.intropage3_body,
        buttonLabel: strings.intropage3_step1,
        onPressed: () async {
          await Permission.ignoreBatteryOptimizations.request();
          ref.invalidate(currentStepProvider);
        },
        onRecheck: () => ref.invalidate(currentStepProvider),
      ),
      _ => _buildStepLayout(
        context,
        body: strings.intropage3_done_body,
        buttonLabel: strings.intropage3_step2,
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isFirstRun', false);

          if (context.mounted) {
            Navigator.of(context).pushReplacementNamed('/home');
          }
        },
      ),
    };
  }

  static Widget _buildStepLayout(
    BuildContext context, {
    required String body,
    required String buttonLabel,
    required VoidCallback onPressed,
    VoidCallback? onRecheck,
  }) {
    final theme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Text(
          body,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: theme.onSurfaceVariant),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: 300,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: onPressed,
            child: Text(buttonLabel),
          ),
        ),
        if (onRecheck != null)
          TextButton(
            onPressed: onRecheck,
            child: Text(S.of(context).intropage3_recheck),
          ),
      ],
    );
  }
}
