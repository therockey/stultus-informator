// Temporary visual preview harness.
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:informator/generated/l10n.dart';
import 'package:informator/screens/home_screen.dart';
import 'package:informator/theme.dart';
import 'package:material_ui/material_ui.dart';

const _fontDir =
    r'C:\Users\kacpe\AppData\Local\flutter\bin\cache\artifacts\material_fonts';

Future<void> _loadFont(String family, List<String> files) async {
  final loader = FontLoader(family);
  for (final file in files) {
    final bytes = File('$_fontDir\\$file').readAsBytesSync();
    loader.addFont(Future.value(ByteData.view(bytes.buffer)));
  }
  await loader.load();
}

Future<void> _pump(
  WidgetTester tester, {
  required ColorScheme scheme,
  required Size size,
  required String golden,
}) async {
  tester.view.physicalSize = Size(size.width * 2, size.height * 2);
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: const Locale('pl'),
        localizationsDelegates: [
          S.delegate,
          ...GlobalMaterialLocalizations.delegates,
        ],
        supportedLocales: S.delegate.supportedLocales,
        theme: ThemeData(colorScheme: scheme),
        home: const HomeScreen(),
      ),
    ),
  );
  await tester.pumpAndSettle();

  await tester.tap(find.byIcon(Icons.home));
  await tester.pumpAndSettle();

  await expectLater(find.byType(MaterialApp), matchesGoldenFile(golden));
}

void main() {
  group('preview', skip: 'Windows-only golden harness with a local font path', () {
    setUpAll(() async {
      await _loadFont('Roboto', [
        'roboto-regular.ttf',
        'roboto-medium.ttf',
        'roboto-bold.ttf',
        'roboto-black.ttf',
      ]);
      await _loadFont('MaterialIcons', ['materialicons-regular.otf']);
    });

    testWidgets('groups dark', (tester) async {
      await _pump(
        tester,
        scheme: MaterialTheme.darkScheme(),
        size: const Size(412, 892),
        golden: 'preview_groups_dark.png',
      );
    });

    testWidgets('groups light', (tester) async {
      await _pump(
        tester,
        scheme: MaterialTheme.lightScheme(),
        size: const Size(412, 892),
        golden: 'preview_groups_light.png',
      );
    });
  });
}
