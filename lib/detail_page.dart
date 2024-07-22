import 'package:flutter/material.dart';
import 'improvement_item.dart';
import 'database_helper.dart';
import 'mood_chart.dart';
import 'mood.dart';
import 'powerpoint_helper.dart'; // Import the PowerPointHelper
import 'package:share_plus/share_plus.dart'; // Import share_plus
import 'package:path/path.dart' as path; // Import for path operations

class DetailPage extends StatefulWidget {
  final ImprovementItem item;

  const DetailPage({super.key, required this.item});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _championController;
  late TextEditingController _issueController;
  late TextEditingController _improvementController;
  late TextEditingController _outcomeController;
  List<Mood> _moods = [];
  late int _tempId;
  late bool _isNewItem = false;
  String _impactLevel = 'high';

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.item.title);
    _impactLevel =
        widget.item.impactLevel.isNotEmpty ? widget.item.impactLevel : 'high';
    _championController = TextEditingController(text: widget.item.champion);
    _issueController = TextEditingController(text: widget.item.issue);
    _improvementController =
        TextEditingController(text: widget.item.improvement);
    _outcomeController = TextEditingController(text: widget.item.outcome);

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
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _championController.dispose();
    _issueController.dispose();
    _improvementController.dispose();
    _outcomeController.dispose();
    super.dispose();
  }

  Future<void> _sharePowerPoint() async {
    try {
      final file = await PowerPointHelper.createPowerPoint(widget.item);
      if (!mounted) return;
      final xFile = XFile(file.path, name: path.basename(file.path));
      await Share.shareXFiles([xFile], text: 'Improvement Item PowerPoint');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating PowerPoint: $e')),
      );
    }
  }

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      final newItem = ImprovementItem(
        id: _isNewItem ? _tempId : widget.item.id,
        title: _titleController.text,
        impactLevel: _impactLevel,
        champion: _championController.text,
        issue: _issueController.text,
        improvement: _improvementController.text,
        outcome: _outcomeController.text,
        feeling: '', // Remove feeling logic
      );

      if (_isNewItem) {
        await DatabaseHelper().insertImprovementItem(newItem);
      } else {
        await DatabaseHelper().updateImprovementItem(newItem);
      }

      if (!mounted) return;
      Navigator.pop(context, true);
    }
  }

  void _saveMood(String mood) async {
    final itemId = _isNewItem ? _tempId : widget.item.id;
    await DatabaseHelper().insertMood(itemId, mood);
    await _loadMoods();
  }

/*
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
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Improvement Item'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _sharePowerPoint, // Add this line
          ),
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
              DropdownButtonFormField<String>(
                value: _impactLevel,
                decoration: const InputDecoration(labelText: 'Impact Level'),
                items: ['high', 'medium', 'low']
                    .map((level) => DropdownMenuItem(
                          value: level,
                          child: Text(level),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _impactLevel = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select an impact level';
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
                maxLines: 3,
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
                maxLines: 3,
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
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an outcome';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              const Text('Mood Chart'),
              SizedBox(
                height: 200,
                child: MoodChart(
                  improvementItemId: _isNewItem ? _tempId : widget.item.id,
                  moods: _moods,
                  reloadMoodsCallback: _loadMoods,
                ),
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
