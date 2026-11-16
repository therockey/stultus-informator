import 'package:material_ui/material_ui.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:informator/generated/l10n.dart';

class Page2 extends PageViewModel {
  // ignore: unused_field
  final WidgetRef _ref;

  // ignore: unused_field
  final BuildContext _context;

  Page2(this._context, this._ref)
    : super(
        title: S.of(_context).intropage2_title,
        bodyWidget: Text(
          S.of(_context).intropage2_body,
          textAlign: TextAlign.justify,
          style: TextStyle(fontSize: 16),
        ),
        image: Center(
          child: Image.asset(
            'assets/intro2.png',
            semanticLabel: S.of(_context).intropage2_semantics,
          ),
        ),
        decoration: PageDecoration(
          imagePadding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          imageAlignment: Alignment.center,
          titleTextStyle: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.w700,
          ),
          pageColor: Theme.of(_context).colorScheme.surface,
        ),
      );
}
