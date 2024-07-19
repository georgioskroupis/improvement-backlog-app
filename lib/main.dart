import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'improvement_item.dart';
import 'detail_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Improvement Backlog App',
      home: MyHomePage(title: 'Improvement Backlog'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<ImprovementItem>> _improvementItems;

  @override
  void initState() {
    super.initState();
    _improvementItems = DatabaseHelper().getImprovementItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                    child: Text('Title',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold))),
                Expanded(
                    child: Text('Feeling',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center)),
                Expanded(
                    child: Text('Champion',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.right)),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: FutureBuilder<List<ImprovementItem>>(
              future: _improvementItems,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('No improvement items found.'));
                } else {
                  final items = snapshot.data!;
                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return ListTile(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPage(item: item),
                            ),
                          );
                          if (result == true) {
                            setState(() {
                              _improvementItems =
                                  DatabaseHelper().getImprovementItems();
                            });
                          }
                        },
                        title: Row(
                          children: [
                            Expanded(
                                child: Text(item.title,
                                    style: const TextStyle(fontSize: 16))),
                            Expanded(
                                child: Text(item.feeling,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 16))),
                            Expanded(
                                child: Text(item.champion,
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(fontSize: 16))),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newId = (await DatabaseHelper().getNextId()) + 1;
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailPage(
                item: ImprovementItem(
                  id: newId,
                  title: '',
                  impactLevel: '',
                  champion: '',
                  issue: '',
                  improvement: '',
                  outcome: '',
                  feeling: '',
                ),
              ),
            ),
          );
          if (result == true) {
            setState(() {
              _improvementItems = DatabaseHelper().getImprovementItems();
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
