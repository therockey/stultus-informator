import 'package:hooks_riverpod/hooks_riverpod.dart';

final homeTabIndexProvider = NotifierProvider<HomeTabIndexNotifier, int>(
  HomeTabIndexNotifier.new,
);

class HomeTabIndexNotifier extends Notifier<int> {
  @override
  int build() => 1;

  void setIndex(int index) => state = index;
}
