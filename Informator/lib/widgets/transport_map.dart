import 'package:informator/generated/l10n.dart';
import 'package:informator/models/service.dart';
import 'package:informator/models/transport.dart';
import 'package:informator/widgets/service_status.dart';
import 'package:material_ui/material_ui.dart';

/// Schematic map of transport lines, drawn from the route geometry stored in
/// the database (no external map SDK, like [OutageHeatmap]).
///
/// The disrupted segment of a line is painted in the status colour and, when
/// an area is given, the affected area is marked with a translucent circle.
class TransportMap extends StatelessWidget {
  const TransportMap({
    super.key,
    required this.lines,
    this.areaX,
    this.areaY,
    this.areaRadius,
    this.height = 168,
  });

  final List<TransportLine> lines;

  /// Centre and radius of the affected area, normalised to the 0..1 range.
  final double? areaX;

  final double? areaY;

  final double? areaRadius;

  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Semantics(
      label: S.of(context).transport_map_semantics,
      child: ExcludeSemantics(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            height: height,
            width: double.infinity,
            child: CustomPaint(
              painter: _TransportMapPainter(
                lines: lines,
                areaX: areaX,
                areaY: areaY,
                areaRadius: areaRadius,
                background: theme.surfaceContainerHigh,
                grid: theme.outlineVariant.withValues(alpha: 0.5),
                lineColor: theme.onSurfaceVariant.withValues(alpha: 0.6),
                labelBackground: theme.secondary,
                labelForeground: theme.onSecondary,
              ),
              child: const SizedBox.expand(),
            ),
          ),
        ),
      ),
    );
  }
}

class _TransportMapPainter extends CustomPainter {
  _TransportMapPainter({
    required this.lines,
    required this.areaX,
    required this.areaY,
    required this.areaRadius,
    required this.background,
    required this.grid,
    required this.lineColor,
    required this.labelBackground,
    required this.labelForeground,
  });

  final List<TransportLine> lines;
  final double? areaX;
  final double? areaY;
  final double? areaRadius;
  final Color background;
  final Color grid;
  final Color lineColor;
  final Color labelBackground;
  final Color labelForeground;

  static const double _padding = 16;
  static const int _gridDivisions = 6;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = background);

    final gridPaint = Paint()
      ..color = grid
      ..strokeWidth = 1;
    for (var step = 1; step < _gridDivisions; step++) {
      final dx = size.width * step / _gridDivisions;
      final dy = size.height * step / _gridDivisions;
      canvas.drawLine(Offset(dx, 0), Offset(dx, size.height), gridPaint);
      canvas.drawLine(Offset(0, dy), Offset(size.width, dy), gridPaint);
    }

    final drawable = Rect.fromLTWH(
      _padding,
      _padding,
      size.width - 2 * _padding,
      size.height - 2 * _padding,
    );
    Offset project(double x, double y) =>
        Offset(drawable.left + x * drawable.width, drawable.top + y * drawable.height);

    final centerX = areaX;
    final centerY = areaY;
    final radius = areaRadius;
    if (centerX != null && centerY != null && radius != null && lines.isNotEmpty) {
      final color = kServiceStatusColors[lines.first.status]!;
      final center = project(centerX, centerY);
      final pixelRadius = radius * drawable.shortestSide;
      canvas.drawCircle(
        center,
        pixelRadius,
        Paint()..color = color.withValues(alpha: 0.28),
      );
      canvas.drawCircle(
        center,
        pixelRadius,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }

    for (final line in lines) {
      final points = [for (final p in line.route) project(p.x, p.y)];
      if (points.length < 2) continue;

      canvas.drawPath(
        _pathThrough(points),
        _linePaint(lineColor, 4),
      );

      final from = line.disruptedFrom;
      final to = line.disruptedTo;
      if (line.status != ServiceStatus.operational && from != null && to != null) {
        final last = points.length - 1;
        final start = from < 0 ? 0 : (from > last ? last : from);
        final end = to < 0 ? 0 : (to > last ? last : to);
        if (end > start) {
          canvas.drawPath(
            _pathThrough(points.sublist(start, end + 1)),
            _linePaint(kServiceStatusColors[line.status]!, 6),
          );
        }
      }
    }

    // Labels go last so no line is drawn over them.
    for (final line in lines) {
      if (line.route.isEmpty) continue;
      final first = line.route.first;
      _paintLabel(canvas, project(first.x, first.y), line.shortName);
    }
  }

  Path _pathThrough(List<Offset> points) {
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) {
      path.lineTo(point.dx, point.dy);
    }
    return path;
  }

  Paint _linePaint(Color color, double width) {
    return Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
  }

  void _paintLabel(Canvas canvas, Offset at, String text) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: labelForeground,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final rect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: at,
        width: painter.width + 10,
        height: painter.height + 4,
      ),
      const Radius.circular(6),
    );
    canvas.drawRRect(rect, Paint()..color = labelBackground);
    painter.paint(
      canvas,
      Offset(at.dx - painter.width / 2, at.dy - painter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant _TransportMapPainter oldDelegate) {
    return oldDelegate.lines != lines ||
        oldDelegate.areaX != areaX ||
        oldDelegate.areaY != areaY ||
        oldDelegate.areaRadius != areaRadius ||
        oldDelegate.background != background ||
        oldDelegate.lineColor != lineColor;
  }
}
