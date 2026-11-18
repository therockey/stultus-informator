import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

/// Returns the first setup step that still needs attention:
/// 1 - notification permission is not granted,
/// 2 - location permission is not granted,
/// 3 - battery optimization is enabled,
/// 4 - setup is complete (or the battery check does not apply).
final currentStepProvider = FutureProvider<int>((ref) async {
  if (kIsWeb ||
      (defaultTargetPlatform != TargetPlatform.android &&
          defaultTargetPlatform != TargetPlatform.iOS)) {
    // Desktop has no notification/location/battery plugins — skip to "done".
    return 4;
  }

  final notificationsGranted = await Permission.notification.isGranted;
  if (!notificationsGranted) return 1;

  final locationGranted = await Permission.locationWhenInUse.isGranted;
  if (!locationGranted) return 2;

  if (defaultTargetPlatform != TargetPlatform.android) return 4;

  final batteryStatus = await Permission.ignoreBatteryOptimizations.status;
  return batteryStatus.isDenied || batteryStatus.isPermanentlyDenied ? 3 : 4;
});
