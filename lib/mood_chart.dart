import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'mood.dart';
import 'moods_list.dart';

class MoodChart extends StatelessWidget {
  final int improvementItemId;
  final List<Mood> moods;
  final Function reloadMoodsCallback;

  const MoodChart({
    super.key,
    required this.improvementItemId,
    required this.moods,
    required this.reloadMoodsCallback,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: DatabaseHelper().getMoods(improvementItemId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        final dataPoints = _createData(moods);

        return Padding(
          padding:
              const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 64.0), // Add margins
          child: LineChart(
            LineChartData(
              minY: 1,
              maxY: 3,
              baselineY: 0,
              gridData: const FlGridData(
                show: false, // Hide grid lines
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      switch (value.toInt()) {
                        case 1:
                          return const Text('😢');
                        case 2:
                          return const Text('😐');
                        case 3:
                          return const Text('😊');
                        default:
                          return Container();
                      }
                    },
                  ),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: const AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false, // Hide bottom titles
                  ),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
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
              lineTouchData: LineTouchData(
                touchCallback:
                    (FlTouchEvent event, LineTouchResponse? response) {
                  if (event is FlTapUpEvent &&
                      response != null &&
                      response.lineBarSpots != null) {
                    final spot = response.lineBarSpots!.first;
                    final date =
                        DateTime.fromMillisecondsSinceEpoch(spot.x.toInt());
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MoodsList(date: date),
                      ),
                    ).then((_) {
                      reloadMoodsCallback(); // Call the reloadMoodsCallback when returning
                    });
                  }
                },
              ),
            ),
          ),
        );
      },
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
      print("Date: $date, Average Mood: $averageMood"); // Debug print
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
