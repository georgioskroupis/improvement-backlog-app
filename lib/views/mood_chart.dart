import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MoodChart extends StatelessWidget {
  final List<Map<String, dynamic>> feelings;

  const MoodChart({super.key, required this.feelings});

  @override
  Widget build(BuildContext context) {
    final dataPoints = _createData(feelings);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: SizedBox(
        height: 200,
        child: LineChart(
          LineChartData(
            minY: -1,
            maxY: 1,
            gridData: const FlGridData(show: false),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, _) {
                    switch (value.toInt()) {
                      case 1:
                        return const Text('😊');
                      case 0:
                        return const Text('😐');
                      case -1:
                        return const Text('😢');
                      default:
                        return Container();
                    }
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: true),
              ),
            ),
            borderData: FlBorderData(show: true),
            lineBarsData: [
              LineChartBarData(
                spots: dataPoints,
                isCurved: true,
                color: Colors.blue,
                barWidth: 2,
                isStrokeCapRound: true,
                belowBarData: BarAreaData(show: false),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<FlSpot> _createData(List<Map<String, dynamic>> feelings) {
    final List<FlSpot> spots = [];
    int dayIndex = 0;

    for (var feeling in feelings) {
      final moods = feeling['moods'] as List;
      final averageMood = moods.fold<int>(0, (sum, mood) {
            switch (mood) {
              case 'positive':
                return sum + 1;
              case 'negative':
                return sum - 1;
              default:
                return sum;
            }
          }) /
          moods.length;

      spots.add(FlSpot(dayIndex.toDouble(), averageMood));
      dayIndex++;
    }
    return spots;
  }
}
