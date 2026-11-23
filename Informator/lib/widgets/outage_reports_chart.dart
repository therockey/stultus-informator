import 'package:fl_chart/fl_chart.dart';
import 'package:informator/models/service_details.dart';
import 'package:material_ui/material_ui.dart';

enum ReportPeriod { sevenDays, thirtyDays, ninetyDays }

class OutageReportsChart extends StatelessWidget {
  const OutageReportsChart({
    super.key,
    required this.points,
    this.period = ReportPeriod.sevenDays,
  });

  final List<ReportPoint> points;
  final ReportPeriod period;

  List<ReportPoint> _pointsForPeriod() {
    if (points.isEmpty) return const <ReportPoint>[];
    final days = switch (period) {
      ReportPeriod.sevenDays => 7,
      ReportPeriod.thirtyDays => 30,
      ReportPeriod.ninetyDays => 90,
    };
    final end = points.last.day;
    final start = end.subtract(Duration(days: days - 1));
    var recent = points
        .where((point) => !point.day.isBefore(start) && !point.day.isAfter(end))
        .toList(growable: false);
    if (period != ReportPeriod.ninetyDays) return recent;

    final weeks = <ReportPoint>[];
    for (var index = 0; index < recent.length; index += 7) {
      final chunk = recent.skip(index).take(7).toList(growable: false);
      if (chunk.isEmpty) continue;
      final total = chunk.fold<int>(0, (sum, point) => sum + point.count);
      weeks.add(ReportPoint(day: chunk.last.day, count: total));
    }
    return weeks;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final filtered = _pointsForPeriod();
    if (filtered.isEmpty) {
      return const SizedBox.shrink();
    }

    final maxCount = filtered
        .map((point) => point.count)
        .fold<int>(0, (current, count) => count > current ? count : current);
    final labelInterval = switch (period) {
      ReportPeriod.sevenDays => 1.0,
      ReportPeriod.thirtyDays => 5.0,
      ReportPeriod.ninetyDays => 2.0,
    };

    return SizedBox(
      height: 180,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: (filtered.length - 1).toDouble(),
          minY: 0,
          maxY: (maxCount == 0 ? 4 : maxCount).toDouble() * 1.2,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) =>
                FlLine(color: theme.outlineVariant, strokeWidth: 1),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
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
                    style: TextStyle(
                      color: theme.onSurfaceVariant,
                      fontSize: 10,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: labelInterval,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= filtered.length) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '${filtered[index].day.day}.${filtered[index].day.month}',
                      style: TextStyle(
                        color: theme.onSurfaceVariant,
                        fontSize: 10,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: [
                for (var index = 0; index < filtered.length; index++)
                  FlSpot(index.toDouble(), filtered[index].count.toDouble()),
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
