import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'todo_model.dart';

class ToDoDatabase {
  static final ToDoDatabase instance = ToDoDatabase._init();
  static Database? _database;

  ToDoDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('todos.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
      CREATE TABLE todos (
        id $idType,
        name $textType
      )
    ''');
  }

  Future<ToDo> create(ToDo todo) async {
    final db = await instance.database;
    final id = await db.insert('todos', todo.toMap());
    return todo.copyWith(id: id);
  }

  Future<List<ToDo>> readAllToDos() async {
    final db = await instance.database;
    const orderBy = 'id DESC';
    final result = await db.query('todos', orderBy: orderBy);
    return result.map((map) => ToDo.fromMap(map)).toList();
  }

  Future<List<ToDo>> searchToDos(String keyword) async {
    final db = await instance.database;
    final result = await db.query(
      'todos',
      where: 'name LIKE ?',
      whereArgs: ['%$keyword%'],
    );
    return result.map((map) => ToDo.fromMap(map)).toList();
  }

  Future<int> update(ToDo todo) async {
    final db = await instance.database;
    return db.update(
      'todos',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}

extension on ToDo {
  ToDo copyWith({int? id, String? name}) {
    return ToDo(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}