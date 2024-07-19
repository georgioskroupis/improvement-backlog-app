import 'package:flutter/material.dart';
import 'improvement_item.dart';
import 'database_helper.dart';
import 'mood_chart.dart';
import 'mood.dart';

class DetailPage extends StatefulWidget {
  final ImprovementItem item;

  const DetailPage({super.key, required this.item});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _impactLevelController;
  late TextEditingController _championController;
  late TextEditingController _issueController;
  late TextEditingController _improvementController;
  late TextEditingController _outcomeController;
  late TextEditingController _feelingController;
  List<Mood> _moods = [];
  late int _tempId;
  late bool _isNewItem = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.item.title);
    _impactLevelController =
        TextEditingController(text: widget.item.impactLevel);
    _championController = TextEditingController(text: widget.item.champion);
    _issueController = TextEditingController(text: widget.item.issue);
    _improvementController =
        TextEditingController(text: widget.item.improvement);
    _outcomeController = TextEditingController(text: widget.item.outcome);
    _feelingController = TextEditingController(text: widget.item.feeling);

    _checkItemExists();
  }

  Future<void> _checkItemExists() async {
    final exists =
        await DatabaseHelper().improvementItemExists(widget.item.id ?? -1);
    if (!exists) {
      _isNewItem = true;
      _tempId = await DatabaseHelper().getNextId() + 1;
    } else {
      _isNewItem = false;
      await _loadMoods();
    }
    setState(() {}); // Ensure state update after async operations
  }

  Future<void> _loadMoods() async {
    final moods = await DatabaseHelper().getMoods(widget.item.id ?? -1);
    setState(() {
      _moods = moods.map((e) => Mood.fromMap(e)).toList();
      if (_moods.isNotEmpty) {
        final averageMood = _moods
                .map((mood) => _moodValue(mood.mood))
                .reduce((a, b) => a + b) /
            _moods.length;
        if (averageMood <= 3.0 && averageMood > 2.3) {
          _feelingController.text = "Positive";
        } else if (averageMood <= 2.3 && averageMood > 1.7) {
          _feelingController.text = "Neutral";
        } else if (averageMood <= 1.7 && averageMood >= 1.0) {
          _feelingController.text = "Negative";
        }
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _impactLevelController.dispose();
    _championController.dispose();
    _issueController.dispose();
    _improvementController.dispose();
    _outcomeController.dispose();
    _feelingController.dispose();
    super.dispose();
  }

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      final newItem = ImprovementItem(
        id: _isNewItem ? _tempId : widget.item.id,
        title: _titleController.text,
        impactLevel: _impactLevelController.text,
        champion: _championController.text,
        issue: _issueController.text,
        improvement: _improvementController.text,
        outcome: _outcomeController.text,
        feeling: _feelingController.text,
      );

      if (_isNewItem) {
        await DatabaseHelper().insertImprovementItem(newItem);
      } else {
        await DatabaseHelper().updateImprovementItem(newItem);
      }

      Navigator.pop(context, true);
    }
  }

  void _saveMood(String mood) async {
    final itemId = _isNewItem ? _tempId : widget.item.id;
    await DatabaseHelper().insertMood(itemId, mood);
    await _loadMoods();
  }

  int _moodValue(String mood) {
    switch (mood) {
      case 'positive':
        return 3;
      case 'neutral':
        return 2;
      case 'negative':
        return 1;
      default:
        return 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Improvement Item'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveItem,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _impactLevelController,
                decoration: const InputDecoration(labelText: 'Impact Level'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an impact level';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _championController,
                decoration: const InputDecoration(labelText: 'Champion'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a champion';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _issueController,
                decoration: const InputDecoration(labelText: 'Issue'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an issue';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _improvementController,
                decoration: const InputDecoration(labelText: 'Improvement'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an improvement';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _outcomeController,
                decoration: const InputDecoration(labelText: 'Outcome'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an outcome';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _feelingController,
                decoration: const InputDecoration(labelText: 'Feeling'),
                readOnly: true,
              ),
              const SizedBox(height: 20),
              const Text('Mood Chart'),
              SizedBox(
                height: 200,
                child: MoodChart(
                    improvementItemId: _isNewItem ? _tempId : widget.item.id,
                    moods: _moods),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showMoodSheet(),
        child: const Text('🤔'),
      ),
    );
  }

  void _showMoodSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  _saveMood('positive');
                  Navigator.of(context).pop();
                },
                child: const Text('😊'),
              ),
              ElevatedButton(
                onPressed: () {
                  _saveMood('neutral');
                  Navigator.of(context).pop();
                },
                child: const Text('😐'),
              ),
              ElevatedButton(
                onPressed: () {
                  _saveMood('negative');
                  Navigator.of(context).pop();
                },
                child: const Text('😢'),
              ),
            ],
          ),
        );
      },
    );
  }
}
