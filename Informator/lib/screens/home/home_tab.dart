import 'package:material_ui/material_ui.dart';

class HomeTab {
  const HomeTab({required this.body, this.title});
  final Widget body;
  final String? title;

  String resolveTitle(String? titleOverride) =>
      titleOverride ?? title ?? 'Informator';
}
