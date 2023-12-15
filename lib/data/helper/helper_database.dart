import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:tasks/models/task.dart';

class DatabaseHelper {
  static Database? _database;
  static final _taskTable = 'Tasks';

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await initializeDatabase();
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    final path = join(await getDatabasesPath(), 'taskdatabase.db');

    return openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_taskTable (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      description TEXT
      )
    ''');
  }

Future<int> insertItem(Task task) async {
  final db = await database;
  print('Inserindo tarefa: $task');
  final result = await db.insert('Tasks', task.toMap());
  print('Resultado da inserção: $result');
  return result;
}

  Future<int> updateItem(Task item) async {
    final db = await database;
    return await db.update(
      _taskTable,
      item.toMap(),
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<int> deleteItem(int itemId) async {
    final db = await database;
    return await db.delete(
      _taskTable,
      where: 'id = ?',
      whereArgs: [itemId],
    );
  }

  Future<List<Task>> getItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_taskTable);

    return List.generate(maps.length, (index) {
      return Task.fromMap(maps[index]);
    });
  }
}
