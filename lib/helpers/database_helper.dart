import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:final_project/models/todo_item.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'todo.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE todo(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        description TEXT,
        category TEXT,
        dueDate TEXT,
        priority TEXT,
        isDone INTEGER
      )
    ''');
  }

  Future<int> insertTodo(TodoItem todo) async {
    final db = await database;
    return await db.insert('todo', todo.toMap());
  }

  Future<List<TodoItem>> getTodos() async {
    final db = await database;
    final res = await db.query('todo');
    return res.map((e) => TodoItem.fromMap(e)).toList();
  }

  Future<int> updateTodo(TodoItem todo) async {
    final db = await database;
    return await db.update('todo', todo.toMap(), where: 'id = ?', whereArgs: [todo.id]);
  }

  Future<int> deleteTodo(int id) async {
    final db = await database;
    return await db.delete('todo', where: 'id = ?', whereArgs: [id]);
  }
}
