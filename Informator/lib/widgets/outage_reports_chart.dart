import 'package:fl_chart/fl_chart.dart';
import 'package:informator/models/service_details.dart';
import 'package:material_ui/material_ui.dart';

class OutageReportsChart extends StatelessWidget {
  const OutageReportsChart({super.key, required this.points});

  final List<ReportPoint> points;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    if (points.isEmpty) {
      return const SizedBox.shrink();
    }

    final maxCount = points
        .map((point) => point.count)
        .fold<int>(0, (current, count) => count > current ? count : current);

    return SizedBox(
      height: 180,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: (points.length - 1).toDouble(),
          minY: 0,
          maxY: (maxCount == 0 ? 4 : maxCount).toDouble() * 1.2,
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
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= points.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '${points[index].day.day}',
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
                  FlSpot(index.toDouble(), points[index].count.toDouble()),
              ],
              isCurved: true,
              color: theme.primary,
              barWidth: 3,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: theme.primary.withValues(alpha: 0.16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
