import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'mood.dart';

class MoodsList extends StatefulWidget {
  final DateTime date;

  const MoodsList({super.key, required this.date});

  @override
  _MoodsListState createState() => _MoodsListState();
}

class _MoodsListState extends State<MoodsList> {
  late Future<List<Mood>> _moods;
  List<Mood> _moodsList = [];
  List<Mood> _removedMoods = [];

  @override
  void initState() {
    super.initState();
    _moods = _getMoodsForDate(widget.date);
  }

  Future<List<Mood>> _getMoodsForDate(DateTime date) async {
    final db = await DatabaseHelper().database;
    final String dateString =
        "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    final List<Map<String, dynamic>> maps = await db.query(
      'moods',
      where: "DATE(timestamp) = ?",
      whereArgs: [dateString],
    );
    return List.generate(maps.length, (i) {
      return Mood(
        id: maps[i]['id'],
        improvementItemId: maps[i]['improvement_item_id'],
        mood: maps[i]['mood'],
        timestamp: DateTime.parse(maps[i]['timestamp']),
      );
    });
  }

  Future<void> _deleteMood(int id) async {
    final db = await DatabaseHelper().database;
    await db.delete(
      'moods',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  void _removeMoodFromList(Mood mood) {
    setState(() {
      _moodsList.remove(mood);
      _removedMoods.add(mood);
    });
  }

  void _saveChanges() async {
    for (var mood in _removedMoods) {
      await _deleteMood(mood.id);
    }
    Navigator.pop(context, true); // Return to detail page and refresh data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Moods on ${widget.date.day}/${widget.date.month}/${widget.date.year}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveChanges,
          ),
        ],
      ),
      body: FutureBuilder<List<Mood>>(
        future: _moods,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('No moods available for this date.'));
          } else {
            _moodsList = snapshot.data!;
            return ListView.builder(
              itemCount: _moodsList.length,
              itemBuilder: (context, index) {
                final mood = _moodsList[index];
                return Dismissible(
                  key: Key(mood.id.toString()),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    _removeMoodFromList(mood);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Mood removed')),
                    );
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: ListTile(
                    title: Text(mood.mood),
                    subtitle: Text(mood.timestamp.toString()),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
