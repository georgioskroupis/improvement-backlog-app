import 'package:flutter/material.dart';

class MoodsList extends StatelessWidget {
  final DateTime date;

  const MoodsList({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Moods on ${date.day}/${date.month}/${date.year}'),
      ),
      body: Center(
        child: Text('No moods available for this date.'),
      ),
    );
  }
}
