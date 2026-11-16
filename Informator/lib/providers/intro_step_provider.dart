import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

/// Returns the first setup step that still needs attention:
/// 1 - notification permission is not granted,
/// 2 - battery optimization is enabled,
/// 3 - setup is complete (or the battery check does not apply).
final currentStepProvider = FutureProvider<int>((ref) async {
  if (kIsWeb ||
      (defaultTargetPlatform != TargetPlatform.android &&
          defaultTargetPlatform != TargetPlatform.iOS)) {
    return 3;
  }

  final notificationsGranted = await Permission.notification.isGranted;
  if (!notificationsGranted) return 1;

  if (defaultTargetPlatform != TargetPlatform.android) return 3;

  final batteryStatus = await Permission.ignoreBatteryOptimizations.status;
  return batteryStatus.isDenied || batteryStatus.isPermanentlyDenied ? 2 : 3;
});
