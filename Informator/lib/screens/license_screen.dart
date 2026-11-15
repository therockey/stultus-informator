import 'package:flutter/material.dart';
import 'package:informator/providers/package_info_provider.dart';
import 'package:informator/widgets/future_provider_view_builder.dart';

class LicenseScreen extends StatelessWidget {
  const LicenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return FutureProviderViewBuilder(
      provider: packageInfoProvider,
      viewBuilder: (con, rf, info) {
        return LicensePage(
          applicationName: info.appName,
          applicationVersion: info.version,
          applicationLegalese: '© 2025 Stultus Dev',
        );
      },
    );
  }
}
