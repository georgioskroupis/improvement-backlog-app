import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DailyMoodsPage extends StatelessWidget {
  final DateTime date;
  final List<dynamic> moods;

  const DailyMoodsPage({
    required this.date,
    required this.moods,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Moods on ${DateFormat('dd/MM/yyyy').format(date)}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: moods.length,
          itemBuilder: (context, index) {
            final mood = moods[index];
            return ListTile(
              leading: _getMoodEmoji(mood),
              title: Text(
                'Mood: $mood',
                style: const TextStyle(fontSize: 18),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _getMoodEmoji(String mood) {
    switch (mood) {
      case 'positive':
        return const Text('😊', style: TextStyle(fontSize: 24));
      case 'neutral':
        return const Text('😐', style: TextStyle(fontSize: 24));
      case 'negative':
        return const Text('😢', style: TextStyle(fontSize: 24));
      default:
        return const Text('');
    }
  }
}
