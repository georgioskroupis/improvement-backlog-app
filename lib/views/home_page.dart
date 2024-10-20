import 'package:flutter/material.dart';
import '../controllers/improvement_controller.dart';
import '../models/improvement_item.dart';
import 'detail_page.dart';
import 'mood_chart.dart';

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
            return Center(child: Text('Error: \${snapshot.error}'));
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
                  chart: SizedBox(
                    height: 200.0,
                    child: MoodChart(
                      feelings: item.feelings,
                    ),
                  ),
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

class ImprovementCardView extends StatelessWidget {
  final ImprovementItem item;
  final VoidCallback onTap;
  final Widget chart;

  const ImprovementCardView({
    required this.item,
    required this.onTap,
    required this.chart,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CircleAvatar(
                    child: Text(
                      item.champion.isNotEmpty
                          ? item.champion[0].toUpperCase()
                          : '?',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              chart,
            ],
          ),
        ),
      ),
    );
  }
}
