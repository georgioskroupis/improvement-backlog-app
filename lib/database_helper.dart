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
      onOpen: (db) async {
        // Force recreate tables for development
        await db.execute('DROP TABLE IF EXISTS improvement_items');
        await db.execute('DROP TABLE IF EXISTS moods');
        await _onCreate(db, 1);
      },
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

    await db.execute('''
    CREATE TABLE moods (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      improvement_item_id INTEGER,
      mood TEXT,
      timestamp TEXT,
      FOREIGN KEY (improvement_item_id) REFERENCES improvement_items (id) ON DELETE CASCADE
    )
  ''');

    // Insert sample data for development
    await _insertSampleData(db);
  }

  Future<void> _insertSampleData(Database db) async {
    final count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM improvement_items'));
    if (count == 0) {
      final sampleItems = [
        ImprovementItem(
          id: 1,
          title: 'Sample Item 1',
          impactLevel: 'high',
          champion: 'Champion 1',
          issue: 'Issue 1',
          improvement: 'Improvement 1',
          outcome: 'Outcome 1',
          feeling: 'happy',
        ),
        ImprovementItem(
          id: 2,
          title: 'Sample Item 2',
          impactLevel: 'medium',
          champion: 'Champion 2',
          issue: 'Issue 2',
          improvement: 'Improvement 2',
          outcome: 'Outcome 2',
          feeling: 'neutral',
        ),
        ImprovementItem(
          id: 3,
          title: 'Sample Item 3',
          impactLevel: 'low',
          champion: 'Champion 3',
          issue: 'Issue 3',
          improvement: 'Improvement 3',
          outcome: 'Outcome 3',
          feeling: 'sad',
        ),
      ];

      for (var item in sampleItems) {
        await db.insert('improvement_items', item.toMap());
      }

      final sampleMoods = [
        {
          'improvement_item_id': 1,
          'mood': 'positive',
          'timestamp': DateTime.now()
              .subtract(const Duration(days: 5, hours: 10))
              .toIso8601String(),
        },
        {
          'improvement_item_id': 1,
          'mood': 'neutral',
          'timestamp': DateTime.now()
              .subtract(const Duration(days: 5, hours: 5))
              .toIso8601String(),
        },
        {
          'improvement_item_id': 1,
          'mood': 'negative',
          'timestamp': DateTime.now()
              .subtract(const Duration(days: 3))
              .toIso8601String(),
        },
        {
          'improvement_item_id': 2,
          'mood': 'neutral',
          'timestamp': DateTime.now()
              .subtract(const Duration(days: 7))
              .toIso8601String(),
        },
        {
          'improvement_item_id': 2,
          'mood': 'positive',
          'timestamp': DateTime.now()
              .subtract(const Duration(days: 4, hours: 8))
              .toIso8601String(),
        },
        {
          'improvement_item_id': 2,
          'mood': 'negative',
          'timestamp': DateTime.now()
              .subtract(const Duration(days: 4, hours: 2))
              .toIso8601String(),
        },
        {
          'improvement_item_id': 3,
          'mood': 'negative',
          'timestamp': DateTime.now()
              .subtract(const Duration(days: 6))
              .toIso8601String(),
        },
        {
          'improvement_item_id': 3,
          'mood': 'neutral',
          'timestamp': DateTime.now()
              .subtract(const Duration(days: 4, hours: 10))
              .toIso8601String(),
        },
        {
          'improvement_item_id': 3,
          'mood': 'positive',
          'timestamp': DateTime.now()
              .subtract(const Duration(days: 4, hours: 4))
              .toIso8601String(),
        },
      ];

      for (var mood in sampleMoods) {
        await db.insert('moods', mood);
      }
    }
  }

  Future<int> getNextId() async {
    final db = await database;
    final result =
        await db.rawQuery('SELECT MAX(id) as id FROM improvement_items');
    return result.first['id'] != null ? result.first['id'] as int : 0;
  }

  Future<bool> improvementItemExists(int id) async {
    final db = await database;
    final result = await db.query(
      'improvement_items',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty;
  }

  Future<List<ImprovementItem>> getImprovementItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('improvement_items');

    return List.generate(maps.length, (i) {
      return ImprovementItem(
        id: maps[i]['id'],
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

  Future<int> insertImprovementItem(ImprovementItem item) async {
    final db = await database;
    return await db.insert('improvement_items', item.toMap());
  }

  Future<void> updateImprovementItem(ImprovementItem item) async {
    final db = await database;
    await db.update(
      'improvement_items',
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<void> insertMood(int improvementItemId, String mood) async {
    final db = await database;
    await db.insert('moods', {
      'improvement_item_id': improvementItemId,
      'mood': mood,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> getMoods(int improvementItemId) async {
    final db = await database;
    return await db.query(
      'moods',
      where: 'improvement_item_id = ?',
      whereArgs: [improvementItemId],
    );
  }
}

extension ImprovementItemMap on ImprovementItem {
  Map<String, dynamic> toMap() {
    return {
      'id': id,
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
