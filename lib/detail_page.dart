// lib/detail_page.dart
import 'package:flutter/material.dart';
import 'improvement_item.dart';
import 'database_helper.dart';

class DetailPage extends StatefulWidget {
  final ImprovementItem item;

  const DetailPage({Key? key, required this.item}) : super(key: key);

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
      final updatedItem = ImprovementItem(
        id: widget.item.id,
        title: _titleController.text,
        impactLevel: _impactLevelController.text,
        champion: _championController.text,
        issue: _issueController.text,
        improvement: _improvementController.text,
        outcome: _outcomeController.text,
        feeling: _feelingController.text,
      );
      await DatabaseHelper().updateImprovementItem(updatedItem);
      Navigator.pop(context, true);
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a feeling';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
