import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'daily_moods_page.dart';

class MoodChart extends StatelessWidget {
  final List<Map<String, dynamic>> feelings;
  final bool isCompact;

  const MoodChart({
    required this.feelings,
    this.isCompact = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: LineChart(
        LineChartData(
          minY: -1,
          maxY: 1,
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: !isCompact,
                reservedSize: 32,
                getTitlesWidget: (value, meta) {
                  if (!isCompact) {
                    if (value == 1 || value == 0 || value == -1) {
                      switch (value.toInt()) {
                        case 1:
                          return const Text('😊',
                              style: TextStyle(fontSize: 18));
                        case 0:
                          return const Text('😐',
                              style: TextStyle(fontSize: 18));
                        case -1:
                          return const Text('😢',
                              style: TextStyle(fontSize: 18));
                        default:
                          return const Text('');
                      }
                    }
                  }
                  return const Text('');
                },
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: !isCompact,
                getTitlesWidget: (value, meta) {
                  if (!isCompact) {
                    final int index = value.toInt();
                    if (index >= 0 && index < feelings.length) {
                      final date = DateTime.parse(feelings[index]['date']);
                      return Text(
                        DateFormat('dd/MM/yyyy').format(date),
                        style: const TextStyle(fontSize: 10),
                      );
                    }
                  }
                  return const Text('');
                },
                interval: 1, // Show only available data points on the x-axis
              ),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          gridData: FlGridData(show: false),
          borderData: FlBorderData(
            show: true,
            border: const Border(
              top: BorderSide.none,
              right: BorderSide.none,
              left: BorderSide(width: 1),
              bottom: BorderSide(width: 1),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: _createData(),
              isCurved: true,
              color: Colors.blue,
              barWidth: 2,
              dotData: FlDotData(show: !isCompact),
              belowBarData: BarAreaData(show: false),
            ),
          ],
          lineTouchData: isCompact
              ? LineTouchData(
                  enabled: false,
                )
              : LineTouchData(
                  enabled: true,
                  touchCallback:
                      (FlTouchEvent event, LineTouchResponse? response) {
                    if (event is FlTapUpEvent && response != null) {
                      if (response.lineBarSpots != null &&
                          response.lineBarSpots!.isNotEmpty) {
                        final spot = response.lineBarSpots!.first;
                        final int index = spot.x.toInt();
                        if (index >= 0 && index < feelings.length) {
                          final selectedDate =
                              DateTime.parse(feelings[index]['date']);
                          final moods =
                              feelings[index]['moods'] as List<dynamic>;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DailyMoodsPage(
                                date: selectedDate,
                                moods: moods,
                              ),
                            ),
                          );
                        }
                      }
                    }
                  },
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        final date =
                            DateTime.parse(feelings[spot.x.toInt()]['date']);
                        final averageMood = spot.y;
                        return LineTooltipItem(
                          'Date: ${DateFormat('dd/MM/yyyy').format(date)}\nMood: ${averageMood.toStringAsFixed(1)}',
                          const TextStyle(color: Colors.white),
                        );
                      }).toList();
                    },
                  ),
                ),
        ),
      ),
    );
  }

  List<FlSpot> _createData() {
    final List<FlSpot> spots = [];
    for (int i = 0; i < feelings.length; i++) {
      final moods = feelings[i]['moods'] as List<dynamic>;
      final averageMood = moods.fold<int>(0, (sum, mood) {
            if (mood == 'positive') {
              return sum + 1;
            } else if (mood == 'negative') {
              return sum - 1;
            }
            return sum;
          }) /
          moods.length;
      spots.add(FlSpot(i.toDouble(), averageMood.toDouble()));
    }
    return spots;
  }
}
