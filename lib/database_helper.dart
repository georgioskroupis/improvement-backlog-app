// lib/database_helper.dart
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'improvement_item.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'improvement_backlog.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE improvement_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        impactLevel TEXT,
        champion TEXT,
        issue TEXT,
        improvement TEXT,
        outcome TEXT,
        feeling TEXT
      )
    ''');

    // Insert sample data for development
    await _insertSampleData(db);
  }

  Future<void> _insertSampleData(Database db) async {
    // Check if table is empty
    final count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM improvement_items'));
    if (count == 0) {
      // Insert sample items
      final sampleItems = [
        ImprovementItem(
          title: 'Sample Item 1',
          impactLevel: 'high',
          champion: 'Champion 1',
          issue: 'Issue 1',
          improvement: 'Improvement 1',
          outcome: 'Outcome 1',
          feeling: 'happy',
        ),
        ImprovementItem(
          title: 'Sample Item 2',
          impactLevel: 'medium',
          champion: 'Champion 2',
          issue: 'Issue 2',
          improvement: 'Improvement 2',
          outcome: 'Outcome 2',
          feeling: 'neutral',
        ),
        ImprovementItem(
          title: 'Sample Item 3',
          impactLevel: 'low',
          champion: 'Champion 3',
          issue: 'Issue 3',
          improvement: 'Improvement 3',
          outcome: 'Outcome 3',
          feeling: 'sad',
        ),
        ImprovementItem(
          title: 'Sample Item 4',
          impactLevel: 'high',
          champion: 'Champion 4',
          issue: 'Issue 4',
          improvement: 'Improvement 4',
          outcome: 'Outcome 4',
          feeling: 'happy',
        ),
        ImprovementItem(
          title: 'Sample Item 5',
          impactLevel: 'medium',
          champion: 'Champion 5',
          issue: 'Issue 5',
          improvement: 'Improvement 5',
          outcome: 'Outcome 5',
          feeling: 'neutral',
        ),
      ];

      for (var item in sampleItems) {
        await db.insert('improvement_items', item.toMap());
      }
    }
  }

  Future<List<ImprovementItem>> getImprovementItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('improvement_items');

    return List.generate(maps.length, (i) {
      return ImprovementItem(
        title: maps[i]['title'],
        impactLevel: maps[i]['impactLevel'],
        champion: maps[i]['champion'],
        issue: maps[i]['issue'],
        improvement: maps[i]['improvement'],
        outcome: maps[i]['outcome'],
        feeling: maps[i]['feeling'],
      );
    });
  }

  Future<void> insertImprovementItem(ImprovementItem item) async {
    final db = await database;
    await db.insert('improvement_items', item.toMap());
  }
}

extension ImprovementItemMap on ImprovementItem {
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'impactLevel': impactLevel,
      'champion': champion,
      'issue': issue,
      'improvement': improvement,
      'outcome': outcome,
      'feeling': feeling,
    };
  }
}
