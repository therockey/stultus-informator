import 'package:material_ui/material_ui.dart';

/// Schematic coverage map: labelled streets, no external map SDK.
class OutageHeatmap extends StatelessWidget {
  const OutageHeatmap({super.key, required this.streets});

  final List<String> streets;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    if (streets.isEmpty) {
      return const SizedBox.shrink();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 168,
        child: CustomPaint(
          painter: _HeatmapPainter(
            streets: streets,
            fill: theme.error.withValues(alpha: 0.55),
            cell: theme.surfaceContainerHigh,
            outline: theme.outlineVariant,
            labelColor: theme.onSurface,
          ),
          child: const SizedBox.expand(),
        ),
      ),
    );
  }
}

class _HeatmapPainter extends CustomPainter {
  _HeatmapPainter({
    required this.streets,
    required this.fill,
    required this.cell,
    required this.outline,
    required this.labelColor,
  });

  final List<String> streets;
  final Color fill;
  final Color cell;
  final Color outline;
  final Color labelColor;

  static const _columns = 3;

  @override
  void paint(Canvas canvas, Size size) {
    final rows = (streets.length / _columns).ceil().clamp(1, 3);
    final cellWidth = size.width / _columns;
    final cellHeight = size.height / rows;
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    canvas.drawRect(Offset.zero & size, Paint()..color = cell);

    for (var index = 0; index < streets.length && index < rows * _columns; index++) {
      final column = index % _columns;
      final row = index ~/ _columns;
      final rect = Rect.fromLTWH(
        column * cellWidth + 4,
        row * cellHeight + 4,
        cellWidth - 8,
        cellHeight - 8,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(8)),
        Paint()..color = fill,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(8)),
        Paint()
          ..color = outline
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
      textPainter.text = TextSpan(
        text: streets[index],
        style: TextStyle(
          color: labelColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      );
      textPainter.layout(maxWidth: rect.width - 8);
      textPainter.paint(
        canvas,
        Offset(
          rect.left + 6,
          rect.center.dy - textPainter.height / 2,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _HeatmapPainter oldDelegate) {
    return oldDelegate.streets != streets || oldDelegate.fill != fill;
  }
}
