import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:informator/widgets/success_overlay.dart';
import 'package:informator/widgets/future_provider_view_builder.dart';
import 'package:informator/widgets/app_card.dart';
import 'package:informator/widgets/language_settings_dialog.dart';
import 'package:informator/widgets/lottie_animation.dart';
import 'package:informator/generated/l10n.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Informator',
          style: TextStyle(color: theme.onSurface),
        ),
        centerTitle: true,
        backgroundColor: theme.surfaceContainer,
      ),
      body: null
    );
  }
}
