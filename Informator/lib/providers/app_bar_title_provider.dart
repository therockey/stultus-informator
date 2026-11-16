import 'package:hooks_riverpod/hooks_riverpod.dart';

/// App-wide override for the title displayed in the app bar.
///
/// When the value is null, screens fall back to their own title and finally
/// to the application name.
final appBarTitleOverrideProvider =
    NotifierProvider<AppBarTitleOverrideNotifier, String?>(
      AppBarTitleOverrideNotifier.new,
    );

class AppBarTitleOverrideNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void setTitle(String? title) => state = title;

  void clear() => state = null;
}
