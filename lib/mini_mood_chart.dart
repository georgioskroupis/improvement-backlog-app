import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'mood.dart';

class MiniMoodChart extends StatelessWidget {
  final List<Mood> moods;

  const MiniMoodChart({super.key, required this.moods});

  @override
  Widget build(BuildContext context) {
    final dataPoints = _createData(moods);

    return IgnorePointer(
      child: SizedBox(
        height: 50,
        width: 100,
        child: LineChart(
          LineChartData(
            minY: 1,
            maxY: 3,
            baselineY: 0,
            gridData: const FlGridData(show: false),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                ),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: false,
                ),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border(
                left: BorderSide(color: Colors.black, width: 1),
                bottom: BorderSide(color: Colors.black, width: 1),
                top: BorderSide.none,
                right: BorderSide.none,
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: dataPoints,
                isCurved: true,
                color: Colors.blue,
                barWidth: 2,
                isStrokeCapRound: true,
                belowBarData: BarAreaData(show: false),
                dotData: FlDotData(show: false), // Hide the spots
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<FlSpot> _createData(List<Mood> moods) {
    final Map<DateTime, List<int>> moodMap = {};
    for (var mood in moods) {
      final date = DateTime(
          mood.timestamp.year, mood.timestamp.month, mood.timestamp.day);
      moodMap.putIfAbsent(date, () => []).add(_moodValue(mood.mood));
    }

    final List<FlSpot> spots = [];
    moodMap.forEach((date, values) {
      final averageMood = values.reduce((a, b) => a + b) / values.length;
      spots.add(FlSpot(date.millisecondsSinceEpoch.toDouble(), averageMood));
    });
    return spots;
  }

  int _moodValue(String mood) {
    switch (mood) {
      case 'positive':
        return 3;
      case 'negative':
        return 1;
      default:
        return 2;
    }
  }
}
