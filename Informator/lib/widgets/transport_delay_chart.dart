import 'package:fl_chart/fl_chart.dart';
import 'package:informator/models/transport.dart';
import 'package:material_ui/material_ui.dart';

/// Line chart of a transport line's delay (minutes) over the recorded hours.
class TransportDelayChart extends StatelessWidget {
  const TransportDelayChart({
    super.key,
    required this.points,
    required this.color,
  });

  final List<TransportDelayPoint> points;

  /// Colour of the line, usually the line's status colour.
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    if (points.isEmpty) {
      return const SizedBox.shrink();
    }

    final maxDelay = points
        .map((point) => point.minutes)
        .fold<int>(0, (current, value) => value > current ? value : current);

    return SizedBox(
      height: 180,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: (points.length - 1).toDouble(),
          minY: 0,
          maxY: (maxDelay < 5 ? 5 : maxDelay).toDouble() * 1.2,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) => FlLine(
              color: theme.outlineVariant,
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                getTitlesWidget: (value, meta) {
                  if (value % 1 != 0) {
                    return const SizedBox.shrink();
                  }
                  return Text(
                    value.toInt().toString(),
                    style: TextStyle(color: theme.onSurfaceVariant, fontSize: 10),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 3,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= points.length) {
                    return const SizedBox.shrink();
                  }
                  final hour = points[index].time.hour.toString().padLeft(2, '0');
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '$hour:00',
                      style: TextStyle(color: theme.onSurfaceVariant, fontSize: 10),
                    ),
                  );
                },
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: [
                for (var index = 0; index < points.length; index++)
                  FlSpot(index.toDouble(), points[index].minutes.toDouble()),
              ],
              isCurved: true,
              color: color,
              barWidth: 3,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: color.withValues(alpha: 0.16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tiny, non-interactive version of the delay chart for list items.
class TransportDelaySparkline extends StatelessWidget {
  const TransportDelaySparkline({
    super.key,
    required this.points,
    required this.color,
    this.width = 72,
    this.height = 32,
  });

  final List<TransportDelayPoint> points;

  final Color color;

  final double width;

  final double height;

  @override
  Widget build(BuildContext context) {
    if (points.length < 2) {
      return SizedBox(width: width, height: height);
    }

    final maxDelay = points
        .map((point) => point.minutes)
        .fold<int>(0, (current, value) => value > current ? value : current);

    return ExcludeSemantics(
      child: SizedBox(
        width: width,
        height: height,
        child: LineChart(
          LineChartData(
            minX: 0,
            maxX: (points.length - 1).toDouble(),
            minY: 0,
            maxY: (maxDelay < 5 ? 5 : maxDelay).toDouble(),
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
            titlesData: const FlTitlesData(show: false),
            lineTouchData: const LineTouchData(enabled: false),
            lineBarsData: [
              LineChartBarData(
                spots: [
                  for (var index = 0; index < points.length; index++)
                    FlSpot(index.toDouble(), points[index].minutes.toDouble()),
                ],
                isCurved: true,
                color: color,
                barWidth: 2,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  color: color.withValues(alpha: 0.16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
