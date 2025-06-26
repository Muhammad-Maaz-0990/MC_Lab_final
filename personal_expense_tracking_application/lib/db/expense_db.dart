import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/expense.dart';

class ExpenseDB {
  static final ExpenseDB instance = ExpenseDB._init();
  static Database? _database;

  ExpenseDB._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('expenses.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE expenses (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        amount REAL NOT NULL,
        category TEXT NOT NULL,
        date TEXT NOT NULL
      )
    ''');
  }

  Future<Expense> create(Expense expense) async {
    final db = await instance.database;
    final id = await db.insert('expenses', expense.toMap());
    return expense.copyWith(id: id);
  }

  Future<List<Expense>> readAll() async {
    final db = await instance.database;
    final orderBy = 'date DESC';
    final result = await db.query('expenses', orderBy: orderBy);
    return result.map((json) => Expense.fromMap(json)).toList();
  }

  Future<int> update(Expense expense) async {
    final db = await instance.database;
    return db.update('expenses', expense.toMap(), where: 'id = ?', whereArgs: [expense.id]);
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete('expenses', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Expense>> readRecent(int count) async {
    final db = await instance.database;
    final result = await db.query('expenses', orderBy: 'date DESC', limit: count);
    return result.map((json) => Expense.fromMap(json)).toList();
  }

  Future<List<Expense>> readFiltered({String? category, DateTime? start, DateTime? end}) async {
    final db = await instance.database;
    String where = '';
    List<dynamic> args = [];
    if (category != null) {
      where += 'category = ?';
      args.add(category);
    }
    if (start != null) {
      if (where.isNotEmpty) where += ' AND ';
      where += 'date >= ?';
      args.add(start.toIso8601String());
    }
    if (end != null) {
      if (where.isNotEmpty) where += ' AND ';
      where += 'date <= ?';
      args.add(end.toIso8601String());
    }
    final result = await db.query('expenses', where: where.isEmpty ? null : where, whereArgs: args, orderBy: 'date DESC');
    return result.map((json) => Expense.fromMap(json)).toList();
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}

extension ExpenseCopy on Expense {
  Expense copyWith({int? id, String? title, double? amount, String? category, DateTime? date}) {
    return Expense(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
    );
  }
} 