import 'package:flutter/material.dart';
import '../controllers/improvement_controller.dart';
import '../models/improvement_item.dart';
import 'detail_page.dart';
import 'improvement_card_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ImprovementController _improvementController = ImprovementController();
  late Future<List<ImprovementItem>> _improvementItems;

  @override
  void initState() {
    super.initState();
    _loadImprovementItems();
  }

  void _loadImprovementItems() {
    setState(() {
      _improvementItems = _improvementController.fetchImprovementItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Improvement Backlog'),
      ),
      body: FutureBuilder<List<ImprovementItem>>(
        future: _improvementItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No improvement items found.'));
          } else {
            final items = snapshot.data!;
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ImprovementCardView(
                  item: item,
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(item: item),
                      ),
                    );
                    if (result == true) {
                      _loadImprovementItems();
                    }
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newItem = ImprovementItem(
            title: '',
            impactLevel: '',
            champion: '',
            issue: '',
            improvement: '',
            outcome: '',
            feelings: [],
          );
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailPage(item: newItem),
            ),
          );
          if (result == true) {
            _loadImprovementItems();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
