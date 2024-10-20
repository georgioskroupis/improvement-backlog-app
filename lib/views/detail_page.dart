import 'package:flutter/material.dart';
import '../models/improvement_item.dart';
import '../controllers/improvement_controller.dart';
import 'mood_chart.dart';

class DetailPage extends StatefulWidget {
  final ImprovementItem item;

  const DetailPage({super.key, required this.item});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final _formKey = GlobalKey<FormState>();
  final ImprovementController _improvementController = ImprovementController();
  late TextEditingController _titleController;
  late TextEditingController _championController;
  late TextEditingController _issueController;
  late TextEditingController _improvementControllerText;
  late TextEditingController _outcomeController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.item.title);
    _championController = TextEditingController(text: widget.item.champion);
    _issueController = TextEditingController(text: widget.item.issue);
    _improvementControllerText =
        TextEditingController(text: widget.item.improvement);
    _outcomeController = TextEditingController(text: widget.item.outcome);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _championController.dispose();
    _issueController.dispose();
    _improvementControllerText.dispose();
    _outcomeController.dispose();
    super.dispose();
  }

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      final newItem = ImprovementItem(
        id: widget.item.id,
        title: _titleController.text,
        impactLevel: widget.item.impactLevel,
        champion: _championController.text,
        issue: _issueController.text,
        improvement: _improvementControllerText.text,
        outcome: _outcomeController.text,
        feelings: widget.item.feelings,
      );
      await _improvementController.addOrUpdateImprovementItem(newItem);
      if (!mounted) return;
      Navigator.pop(context, true);
    }
  }

  void _showAddMoodBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => _addMood('positive'),
                child: const Text('😊'),
              ),
              ElevatedButton(
                onPressed: () => _addMood('neutral'),
                child: const Text('😐'),
              ),
              ElevatedButton(
                onPressed: () => _addMood('negative'),
                child: const Text('😢'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _addMood(String mood) async {
    final date = DateTime.now().toIso8601String().split('T').first;
    await _improvementController.addMood(widget.item.id!, date, mood);
    setState(() {
      if (widget.item.feelings.any((feeling) => feeling['date'] == date)) {
        widget.item.feelings
            .firstWhere((feeling) => feeling['date'] == date)['moods']
            .add(mood);
      } else {
        widget.item.feelings.add({
          'date': date,
          'moods': [mood]
        });
      }
    });
    Navigator.pop(context); // Close the bottom sheet after input
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
                controller: _improvementControllerText,
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
              const Text('Mood Chart:'),
              SizedBox(
                height: 200.0, // Bounded height to avoid infinite size issues
                child: MoodChart(
                  feelings: widget.item.feelings,
                  isCompact: false,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddMoodBottomSheet,
        child: const Icon(Icons.add),
      ),
    );
  }
}
