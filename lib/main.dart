import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'database_helper.dart';
import 'improvement_item.dart';
import 'detail_page.dart';
import 'mood.dart';
import 'mini_mood_chart.dart';

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
  bool _showDeleteDialog = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    _improvementItems = DatabaseHelper().getImprovementItems();
  }

  Future<void> _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _showDeleteDialog = prefs.getBool('showDeleteDialog') ?? true;
    });
  }

  Future<void> _deleteImprovementItem(int id) async {
    final db = await DatabaseHelper().database;
    await db.delete('improvement_items', where: 'id = ?', whereArgs: [id]);
    setState(() {
      _improvementItems = DatabaseHelper().getImprovementItems();
    });
  }

  Future<void> _confirmDelete(BuildContext context, ImprovementItem item,
      Function() onDismissed) async {
    bool neverShowAgain = false;
    if (_showDeleteDialog) {
      bool? shouldDelete = await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text('Confirm Delete'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Are you sure you want to delete this item?'),
                    Row(
                      children: [
                        Checkbox(
                          value: neverShowAgain,
                          onChanged: (value) {
                            setState(() {
                              neverShowAgain = value ?? false;
                            });
                          },
                        ),
                        const Text('Never show again'),
                      ],
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Delete'),
                  ),
                ],
              );
            },
          );
        },
      );

      if (shouldDelete == true) {
        if (neverShowAgain) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool('showDeleteDialog', false);
          setState(() {
            _showDeleteDialog = false;
          });
        }
        onDismissed();
      }
    } else {
      onDismissed();
    }
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
                      return Dismissible(
                        key: Key(item.id.toString()),
                        direction: DismissDirection.endToStart,
                        confirmDismiss: (direction) async {
                          bool shouldDelete = false;
                          await _confirmDelete(context, item, () {
                            shouldDelete = true;
                          });
                          return shouldDelete;
                        },
                        onDismissed: (direction) {
                          _deleteImprovementItem(item.id ?? -1);
                        },
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: ListTile(
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
                                child:
                                    FutureBuilder<List<Map<String, dynamic>>>(
                                  future:
                                      DatabaseHelper().getMoods(item.id ?? -1),
                                  builder: (context, moodSnapshot) {
                                    if (moodSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    } else if (moodSnapshot.hasError) {
                                      return Center(
                                          child: Text(
                                              'Error: ${moodSnapshot.error}'));
                                    } else if (!moodSnapshot.hasData ||
                                        moodSnapshot.data!.isEmpty) {
                                      return const Center(
                                          child: Text('No data'));
                                    } else {
                                      final moods = moodSnapshot.data!
                                          .map((e) => Mood.fromMap(e))
                                          .toList();
                                      return MiniMoodChart(moods: moods);
                                    }
                                  },
                                ),
                              ),
                              Expanded(
                                  child: Text(item.champion,
                                      textAlign: TextAlign.right,
                                      style: const TextStyle(fontSize: 16))),
                            ],
                          ),
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
