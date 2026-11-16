import 'package:material_ui/material_ui.dart';

class HomeTab {
  const HomeTab({required this.body, this.title, this.floatingActionButton});
  final Widget body;
  final String? title;
  final Widget? floatingActionButton;

  String resolveTitle(String? titleOverride) =>
      titleOverride ?? title ?? 'Informator';
}
